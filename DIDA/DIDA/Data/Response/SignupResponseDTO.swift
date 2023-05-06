//
//  SignupResponseDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import Foundation

struct SignupResponseDTO: Codable {
    let accessToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
