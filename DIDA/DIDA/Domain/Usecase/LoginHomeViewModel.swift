//
//  LoginHomeViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift
import RxCocoa

class LoginHomeViewModel: BaseViewModel {
    
    struct Input {
        let tapCloseButton = PublishSubject<Void>()
        let tapKakaoLoginButton = PublishSubject<Void>()
        let tapAppleLoginButton = PublishSubject<Void>()
    }
    
    let input: Input = Input()
    let disposeBag = DisposeBag()
    let userSessionRepository: UserRepository
    
    override init() {
        self.userSessionRepository = UserRepositoryImpl()
    }
    
    override func bind() {
        self.input.tapKakaoLoginButton.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.userSessionRepository.login(type: .kakao)
        }.disposed(by: self.disposeBag)
        
        self.input.tapAppleLoginButton.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.userSessionRepository.login(type: .apple)
        }.disposed(by: self.disposeBag)
    }
}
