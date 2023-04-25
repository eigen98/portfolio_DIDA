//
//  UserRepository.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

enum LoginProvider {
    case apple
    case kakao
}

protocol UserRepository {
    func login(type: LoginProvider)
    
    func isLogin() -> Bool
    func fetchMyself() -> UserEntity?
}
