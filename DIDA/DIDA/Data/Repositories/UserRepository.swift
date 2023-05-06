//
//  UserRepository.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import RxSwift

protocol UserRepository {
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> ())
    func signup(email: String, nickname: String, completion: @escaping (Error?) -> ())
    
    func isLogin() -> Bool
    func fetchMyself() -> UserEntity?
}
