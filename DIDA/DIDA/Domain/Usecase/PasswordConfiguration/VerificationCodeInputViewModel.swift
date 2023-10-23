//
//  VerificationCodeInputViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/23.
//

import Foundation
import RxSwift
import RxCocoa

class VerificationCodeInputViewModel: BaseViewModel {
    
    struct Input {
        let retryButtonTapped = PublishRelay<Void>()
        let codeEntered = BehaviorRelay<String?>(value: nil)
        let confirmButtonTapped =  PublishRelay<Void>()
    }
    
    struct Output {
        let timerText: Observable<String>
        let timerExpired: Observable<Bool>
        let verificationSuccess: Observable<Bool>
    }
    
    private let userRepository: UserRepository
    private var timer: Disposable?
    private var inputNumber = ""
    private var randomNumber = ""
    
    private let timerTextRelay = BehaviorRelay<String>(value: "05:00")
    private let timerExpiredRelay = BehaviorRelay<Bool>(value: false)
    private let verificationSuccessRelay = BehaviorRelay<Bool>(value: false)
    
    let input: Input
    let output: Output
    let disposeBag = DisposeBag()
    
    override init() {
        self.userRepository = UserRepositoryImpl()
        self.input = Input()
        
        self.output = Output(
            timerText: self.timerTextRelay.asObservable(),
            timerExpired: self.timerExpiredRelay.asObservable(),
            verificationSuccess: self.verificationSuccessRelay.asObservable()
        )
        
        super.init()
        
       
    }
    
    override func bind() {
        super.bind()
        self.input.retryButtonTapped.subscribe(onNext: { [weak self] in
            self?.sendVerificationEmail()
        }).disposed(by: self.disposeBag)
        
        self.input.codeEntered.subscribe(onNext: { [weak self] code in
            self?.inputNumber = code ?? ""
        }).disposed(by: self.disposeBag)
        
        self.input.confirmButtonTapped
            .subscribe(onNext: {[weak self] in
                self?.verifyCode(code: self?.inputNumber)
            }).disposed(by: self.disposeBag)
    }
    
    func sendVerificationEmail() {
        self.userRepository.sendAuthenticationEmail { [weak self] (randomString, error) in
            
            if let error = error {
                self?.showError.onNext(error)
                return
            }
            self?.startTimer()
            self?.randomNumber = randomString ?? ""
        }
    }
    
    func startTimer() {
        let totalSeconds = 300
        var secondsRemaining = totalSeconds
        self.timerExpiredRelay.accept(false)
        self.timer?.dispose()
        self.timer = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            secondsRemaining -= 1
            let minutes = secondsRemaining / 60
            let seconds = secondsRemaining % 60
            self?.timerTextRelay.accept(String(format: "%02d:%02d", minutes, seconds))
            
            if secondsRemaining <= 0 {
                self?.timerExpiredRelay.accept(true)
                self?.timer?.dispose()
            }
        })
        
        self.timer?.disposed(by: self.disposeBag)
    }
    
    func verifyCode(code: String?) {
        guard timerExpiredRelay.value == false else { return }
        if code == randomNumber {
            verificationSuccessRelay.accept(true)
            timer?.dispose()
            timer = nil
        }
    }
}
