//
//  PasswordConfigurationViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/16.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordConfigurationViewModel: BaseViewModel {
    enum PasswordStep {
        case setPassword
        case confirmSetPassword
        case enterPassword
    }
    
    var passwordStep = BehaviorRelay<PasswordStep>(value: .setPassword)
    private var setPassword = BehaviorRelay<String>(value: "")
    private var confirmSetPassword = BehaviorRelay<String>(value: "")
    private var enteredPassword = BehaviorRelay<String>(value: "")

    var isPasswordMatched: Observable<Bool> {
        return Observable.combineLatest(setPassword, enteredPassword)
            .map { $0 == $1 }
    }

    override func bind() {

    }

    func numberButtonTapped(value: Int) {
        switch passwordStep.value {
        case .setPassword:
            if setPassword.value.count < 6 {
                setPassword.accept(setPassword.value + "\(value)")
            } else {
                self.showError.onNext(CustomError.passwordLimitExceeded)
            }
        case .confirmSetPassword:
            if confirmSetPassword.value.count < 6 {
                confirmSetPassword.accept(confirmSetPassword.value + "\(value)")
            } else {
                self.showError.onNext(CustomError.passwordLimitExceeded)
            }
        case .enterPassword:
            if enteredPassword.value.count < 6 {
                enteredPassword.accept(enteredPassword.value + "\(value)")
            } else {
                self.showError.onNext(CustomError.passwordLimitExceeded)
            }
        }
    }

    func deleteButtonTapped() {
        switch passwordStep.value {
        case .setPassword:
            if !setPassword.value.isEmpty {
                setPassword.accept(String(setPassword.value.dropLast()))
            }
        case .confirmSetPassword:
            if !confirmSetPassword.value.isEmpty {
                confirmSetPassword.accept(String(confirmSetPassword.value.dropLast()))
            }
        case .enterPassword:
            if !enteredPassword.value.isEmpty {
                enteredPassword.accept(String(enteredPassword.value.dropLast()))
            }
        }
    }

    func moveToNextStep() {
        switch passwordStep.value {
        case .setPassword:
            passwordStep.accept(.confirmSetPassword)
            
        case .confirmSetPassword:
            if setPassword.value == confirmSetPassword.value {
                passwordStep.accept(.enterPassword)
            } else {
                self.showError.onNext(CustomError.passwordMismatch)
            }
        case .enterPassword:
            if setPassword.value == enteredPassword.value {

            } else {
                self.showError.onNext(CustomError.passwordMismatch)
            }
        }
    }
}

enum CustomError: Error {
    case passwordLimitExceeded
    case passwordMismatch
}

