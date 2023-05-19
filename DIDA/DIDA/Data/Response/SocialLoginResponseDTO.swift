//
//  SocialLoginResponseDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/05.
//

import Foundation

struct SocialLoginResponseDTO: Codable {
    let accessToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
    }
}
