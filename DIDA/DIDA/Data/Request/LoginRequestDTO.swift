//
//  LoginRequestDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import Foundation

struct LoginRequestDTO: Codable {
    var type: SocialType = .kakao
    let idToken: String
    
    init(type: SocialType, idToken: String) {
        self.type = type
        self.idToken = idToken
    }
    
    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
    }
}
