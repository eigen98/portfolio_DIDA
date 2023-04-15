//
//  LoginHomeViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginHomeViewModelInput {
    var tapKakaoLoginButton: PublishSubject<Void> { get }
    var tapAppleLoginButton: PublishSubject<Void> { get }
}

class LoginHomeViewModel: BaseViewModel {
    
    let disposeBag = DisposeBag()
    let userSessionRepository: UserRepository
    
    override init() {
        self.userSessionRepository = UserRepositoryImpl()
    }
    
    override func bind() {
        tapAppleLoginButton.bind { [weak self] _ in
            guard let `self` = self else { return }
            
        }.disposed(by: self.disposeBag)
    }
}

extension LoginHomeViewModel: LoginHomeViewModelInput {
    var tapKakaoLoginButton: PublishSubject<Void> {
        return .init()
    }
    var tapAppleLoginButton: PublishSubject<Void> {
        return .init()
    }
}
