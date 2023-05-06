//
//  UserSessionInterface.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

enum SocialType: String {
    case kakao
    case apple
}

protocol UserSessionInterface {
    func login(type: SocialType, completion: @escaping (LoginProviderEntity?, Error?) -> Void)
    func socialLogin(type: SocialType, idToken: String, completion: @escaping (LoginProviderEntity?, Error?) -> ())
    func signup(email: String, nickname: String)
}
