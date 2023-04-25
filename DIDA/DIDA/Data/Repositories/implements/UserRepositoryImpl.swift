//
//  UserRepositoryImpl.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    
    func login(type: LoginProvider) {
        switch type {
        case .apple:
            loginWithApple()
        case .kakao:
            loginWithKakao()
        }
    }
    
    private func loginWithApple() {
        
    }
    
    private func loginWithKakao() {
        UserSession.shared.loginWithKakao { idToken, error in
            
        }
    }
    
    func isLogin() -> Bool {
        return false
    }
    
    func fetchMyself() -> UserEntity? {
        return nil
    }
}
