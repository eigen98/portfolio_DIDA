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

    override init() {
        self.output = Output(
            showError: showErrorSubject.asObservable(),
            passwordStep: passwordStepRelay,
            encryptedPassword: encryptedPasswordRelay,
            walletIssuedSuccessfully: walletIssuedSuccessfullySubject
        )
        super.init()
        
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
        switch passwordStepRelay.value {
        case .setPassword:
            password.append(number)
            if password.count == 6 {
                passwordStepRelay.accept(.confirmSetPassword)
            }
        case .confirmSetPassword:
            confirmPassword.append(number)
            if confirmPassword.count == 6 {
                verifyPasswordsAndEncrypt()
            }
        case .enterPassword:
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
            break
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
    
    private func resetPasswords() {
        password = ""
        confirmPassword = ""
        passwordStepRelay.accept(.setPassword)
    }
}

enum CustomError: Error {
    case passwordLimitExceeded
    case passwordMismatch
}
