//
//  UserRepositoryImpl.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift

class UserRepositoryImpl: UserRepository {
    
    func login(type: LoginProvider){
        switch type {
        case .apple:
            loginWithApple()
        case .kakao:
            loginWithKakao()
        }
    }
    
    private func loginWithApple() {
        
    }
    
    private func loginWithKakao() -> Single<LoginProviderEntity> {
        return Single<Bool>.create { single in
            UserSession.shared.loginWithKakao { idToken, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                if let idToken = idToken {
                    var entity = LoginProviderEntity(idToken: idToken, email: <#T##String?#>, isFirst: <#T##Bool#>)
                }
            }
            
            
            return Disposables.create()
        }
        
    }
    
    func signUp() {
        
    }
    func isLogin() -> Bool {
        return false
    }
    
    func fetchMyself() -> UserEntity? {
        return nil
    }
}
