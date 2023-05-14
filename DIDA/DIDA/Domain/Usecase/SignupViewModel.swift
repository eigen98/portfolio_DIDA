//
//  SignupViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import Foundation
import RxSwift
import RxRelay

class SignupViewModel: BaseViewModel {
    
    struct Input {
        let nicknameInput = BehaviorRelay<String?>(value: nil)
        let email = BehaviorRelay<String?>(value: nil)
    }
    
    struct Output {
        let isSavable: Observable<Bool>
        let isSuccess: Observable<Bool>
    }
    
    private let userRepository: UserRepository
    
    private let isSavable = BehaviorRelay<Bool>(value: false)
    private let isSuccess = BehaviorRelay<Bool>(value: false)
    
    let input: Input
    let output: Output
    let disposeBag = DisposeBag()
    
    override init() {
        self.userRepository = UserRepositoryImpl()
        self.input = Input()
        
        self.output = Output(
            isSavable: self.isSavable.asObservable(),
            isSuccess: self.isSuccess.asObservable()
        )
    }
    
    func signup() {
        guard let email = self.input.email.value else {
            // TODO: error
            return
        }
        
        guard let nickname = self.input.nicknameInput.value else {
            // TODO: error
            return
        }
        
        self.userRepository.signup(email: email, nickname: nickname) { [weak self] error in
            guard let `self` = self else { return }
            
            if let error = error {
                self.showError.onNext(error)
                return
            }
            
            self.isSuccess.accept(true)
        }
    }
    
    func checkDuplictated() {
        guard let nickname = self.input.nicknameInput.value else {
            // TODO: error
            return
        }
        
        self.userRepository.duplicatedNickname(nickname: nickname) { isUsed, error in
            if let error = error {
                self.showError.onNext(error)
                return
            }
            
            guard let isUsed = isUsed else {
                self.isSavable.accept(false)
                return
            }
            
            self.isSavable.accept(!isUsed)
        }
    }
}
