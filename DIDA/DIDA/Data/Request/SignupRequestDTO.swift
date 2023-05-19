//
//  SignupRequestDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/07.
//

import Foundation

struct SignupRequestDTO: Codable {
    let email: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case nickname
    }
}
