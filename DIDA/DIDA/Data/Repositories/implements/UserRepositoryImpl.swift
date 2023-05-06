//
//  UserRepositoryImpl.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift

class UserRepositoryImpl: UserRepository {
    
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> ()) {
        UserSession.shared.login(type: type) { entity, error in
            completion(entity, error)
        }
    }
    
    func signup(email: String, nickname: String, completion: @escaping (Error?) -> ()) {
        UserSession.shared.signup(email: email, nickname: nickname) { error in
            
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func isLogin() -> Bool {
        return false
    }
    
    func fetchMyself() -> UserEntity? {
        return nil
    }
}
