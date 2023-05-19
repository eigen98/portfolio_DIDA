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
    
    struct Output {
        let goToSignup: Observable<Void>
        let successedLogin: Observable<Void>
        let loginEntity: BehaviorRelay<LoginProviderEntity?>
    }
    
    let input: Input = Input()
    let ouptut: Output
    
    private let disposeBag = DisposeBag()
    private let userSessionRepository: UserRepository
    
    private let goToSignup = PublishSubject<Void>()
    private let successedLogin = PublishSubject<Void>()
    
    override init() {
        self.userSessionRepository = UserRepositoryImpl()
        self.ouptut = Output(
            goToSignup: self.goToSignup.asObservable(),
            successedLogin: self.successedLogin.asObservable(),
            loginEntity: .init(value: nil)
        )
    }
    
    override func bind() {
        self.input.tapKakaoLoginButton.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.userSessionRepository.login(type: .kakao) { [weak self] entity, error in
                guard let `self` = self else { return }
                
                if let error = error {
                    self.showError.onNext(error)
                    return
                }
                
                guard let entity = entity else { return }
                
                self.ouptut.loginEntity.accept(entity)
                
                if entity.isFirst {
                    self.goToSignup.onNext(())
                } else {
                    self.successedLogin.onNext(())
                }
            }
        }.disposed(by: self.disposeBag)
        
        self.input.tapAppleLoginButton.bind { [weak self] _ in
            guard let `self` = self else { return }
            
            self.userSessionRepository.login(type: .apple) { [weak self] entity, error in
                guard let `self` = self else { return }
                
                if let error = error  {
                    self.showError.onNext(error)
                    return
                }
                
                guard let entity = entity else { return }
                
                self.ouptut.loginEntity.accept(entity)
                
                if entity.isFirst {
                    self.goToSignup.onNext(())
                } else {
                    self.successedLogin.onNext(())
                }
            }
        }.disposed(by: self.disposeBag)
    }
}
