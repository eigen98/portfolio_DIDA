//
//  PasswordConfigurationViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/16.
//

import Foundation
import RxSwift
import RxCocoa

enum PasswordStep {
    case setPassword
    case confirmSetPassword
    case enterPassword
    case changePassword
}
enum PasswordCheckState {
    case initial
    case matched
    case mismatched(count: Int)
    case exceededLimit
    case passwordChanged
    case error(message: String)
}


class PasswordConfigurationViewModel: BaseViewModel {
    
    struct Input {
        let numberButtonTapped = PublishSubject<String>()
        let deleteButtonTapped = PublishSubject<Void>()
    }
    
    struct Output {
        let showError: Observable<String>
        let passwordStep: BehaviorRelay<PasswordStep>
        let encryptedPassword: BehaviorRelay<String?>
        let walletIssuedSuccessfully: PublishSubject<Void>
        let passwordCheckState: BehaviorRelay<PasswordCheckState>
    }
    
    let input: Input = Input()
    let output: Output
    
    private let disposeBag = DisposeBag()
    private let encryptionService: EncryptionService = RSAEncryptionService()
    private let userRepository: UserRepository = UserRepositoryImpl()

    private var password: String = ""
    private var confirmPassword: String = ""
    private var publicKey: String?
    
    private let showErrorSubject = PublishSubject<String>()
    private let passwordStepRelay = BehaviorRelay<PasswordStep>(value: .setPassword)
    private let encryptedPasswordRelay = BehaviorRelay<String?>(value: nil)
    private let walletIssuedSuccessfullySubject = PublishSubject<Void>()
    private let passwordCheckStateRelay = BehaviorRelay<PasswordCheckState>(value: .initial)

    override init() {
        self.output = Output(
            showError: showErrorSubject.asObservable(),
            passwordStep: passwordStepRelay,
            encryptedPassword: encryptedPasswordRelay,
            walletIssuedSuccessfully: walletIssuedSuccessfullySubject,
            passwordCheckState: passwordCheckStateRelay
        )
        super.init()
        
    }
    
    init(initialStep: PasswordStep = .setPassword) {
        self.output = Output(
            showError: showErrorSubject.asObservable(),
            passwordStep: passwordStepRelay,
            encryptedPassword: encryptedPasswordRelay,
            walletIssuedSuccessfully: walletIssuedSuccessfullySubject,
            passwordCheckState: passwordCheckStateRelay
        )
        super.init()
        self.passwordStepRelay.accept(initialStep)
    }

    
    override func bind() {
        bindNumberButtonTapped()
        bindDeleteButtonTapped()
    }
    
    private func bindNumberButtonTapped() {
        input.numberButtonTapped
            .subscribe(onNext: { [weak self] number in
                guard let self = self else { return }
                self.handleNumberInput(number)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDeleteButtonTapped() {
        input.deleteButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.handleDeleteInput()
            })
            .disposed(by: disposeBag)
    }
    
    private func handleNumberInput(_ number: String) {
        if password.count <= 5{
            password.append(number)
        }
        
        if password.count != 6{
            return
        }

        switch passwordStepRelay.value {
        case .setPassword:
            passwordStepRelay.accept(.confirmSetPassword)
        case .confirmSetPassword:
            verifyPasswordsAndEncrypt()
        case .enterPassword:
            checkPassword()
        case .changePassword:
            modifyPassword()
            break
        }
    }
    
    private func handleDeleteInput() {
        switch passwordStepRelay.value {
        case .setPassword:
            if !password.isEmpty {
                password.removeLast()
            }
        case .confirmSetPassword:
            if !confirmPassword.isEmpty {
                confirmPassword.removeLast()
            }
        case .enterPassword:
            if !password.isEmpty {
                password.removeLast()
            }
        case .changePassword:
            if !password.isEmpty {
                password.removeLast()
            }
        }
    }
    
    private func verifyPasswordsAndEncrypt() {
        if password == confirmPassword {
            handlePasswordMatch()
        } else {
            showErrorSubject.onNext("Passwords do not match.")
            resetPasswords()
        }
    }
    
    private func handlePasswordMatch() {
        fetchPublicKey { [weak self] (publicKey, error) in
            guard let self = self else { return }
            
            if let publicKey = publicKey {
                self.encryptPasswordAndIssueWallet(with: publicKey)
            } else if let error = error {
                self.handlePublicKeyFetchError(error)
            }
            
            self.resetPasswords()
        }
    }

    private func encryptPasswordAndIssueWallet(with publicKey: String) {
        if let encryptedPwd = encryptionService.encryptWithPublicKey(message: password, publicKeyString: publicKey) {
            encryptedPasswordRelay.accept(encryptedPwd)
            issueWallet(with: encryptedPwd)
        } else {
            showErrorSubject.onNext("Encryption failed.")
        }
    }
    
    private func modifyPassword(){
        fetchPublicKey { [weak self] (publicKey, error) in
            guard let self = self else { return }
            
            if let publicKey = publicKey {
                self.encryptAndModifyPassword(with: publicKey)
            } else if let error = error {
                self.showErrorSubject.onNext("\(error)")
            }
        }
    }

    private func handlePublicKeyFetchError(_ error: Error) {
        showErrorSubject.onNext("Failed to fetch public key.")
    }

    
    private func issueWallet(with encryptedPwd: String) {
        userRepository.issueWallet(payPwd: encryptedPwd,
                                   checkPwd: encryptedPwd) { [weak self] (success, error) in
            if let success = success, success {
                self?.walletIssuedSuccessfullySubject.onNext(())
            } else if let error = error {
                self?.showErrorSubject.onNext(error.localizedDescription)
            }
        }
    }
    
    private func fetchPublicKey(completion: @escaping (String?, Error?) -> ()) {
        userRepository.fetchPublicKey { [weak self] (publicKey, error) in
            if let publicKey = publicKey {
                self?.publicKey = publicKey
                completion(publicKey, nil)
            } else if let error = error {
                completion(nil, error)
            }
        }
    }
    
    private func checkPassword() {
        fetchPublicKey { [weak self] (publicKey, error) in
            guard let self = self else { return }
            
            if let publicKey = publicKey {
                self.encryptAndVerifyPassword(with: publicKey)
            } else if let error = error {
                self.showErrorSubject.onNext("\(error)")
            }
        }
    }

    private func encryptAndVerifyPassword(with publicKey: String) {
        guard let encryptedPwd = encryptPassword(with: publicKey) else {
            showErrorSubject.onNext("Encryption failed.")
            return
        }
        verifyEncryptedPassword(encryptedPwd)
    }
    
    private func encryptAndModifyPassword(with publicKey: String) {
        guard let encryptedPwd = encryptPassword(with: publicKey) else {
            showErrorSubject.onNext("Encryption failed.")
            return
        }
        modifyEncryptedPassword(encryptedPwd)
    }
    
    func modifyEncryptedPassword(_ encryptedPwd: String){
        userRepository.changePassword(newPassword: encryptedPwd, completion: {[weak self] (response, error) in
            guard let self = self else { return }
            if let ressult = response{
                self.output.passwordCheckState.accept(.passwordChanged)
            }else if let error = error as? UserRepositoryError {
                
            }else {
               
            }
        })
    }

    private func encryptPassword(with publicKey: String) -> String? {
        return encryptionService.encryptWithPublicKey(message: password, publicKeyString: publicKey)
    }

    private func verifyEncryptedPassword(_ encryptedPwd: String) {
        userRepository.checkPassword(payPwd: encryptedPwd) { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let matched = response?.matched {
                self.handlePasswordVerificationResult(matched: matched, wrongCount: response?.wrongCount)
            } else if let error = error as? UserRepositoryError {
                switch error {
                case .passwordExceededLimit:
                    self.passwordCheckStateRelay.accept(.exceededLimit)
                default:
                    self.passwordCheckStateRelay.accept(.error(message: error.localizedDescription))
                }
            } else {
                self.passwordCheckStateRelay.accept(.error(message: error?.localizedDescription ?? "Unknown error"))
            }
        }
    }

    private func handlePasswordVerificationResult(matched: Bool, wrongCount: Int?) {
        if matched {
            passwordCheckStateRelay.accept(.matched)
        } else {
            passwordCheckStateRelay.accept(.mismatched(count: wrongCount ?? 0))
            resetPasswords()
        }
    }

    private func resetPasswords() {
        password = ""
        confirmPassword = ""
        passwordStepRelay.accept(.setPassword)
    }
}

