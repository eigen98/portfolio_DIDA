//
//  UserRepository.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

class UserReposition: UserRepositoryInterface {
    func login(type: LoginProvider) {
        switch type {
        case .apple: break
        case .kakao:
            UserSession.shared.loginWithKakao { idToken, error in
                
            }
        }
    }
}
