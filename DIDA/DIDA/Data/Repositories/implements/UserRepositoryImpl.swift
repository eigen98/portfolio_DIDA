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
        case .apple: break
        case .kakao:
            UserSession.shared.loginWithKakao { idToken, error in
                
            }
        }
    }
}
