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
    
    func signup() {
        
    }
    
    func isLogin() -> Bool {
        return false
    }
    
    func fetchMyself() -> UserEntity? {
        return nil
    }
}
