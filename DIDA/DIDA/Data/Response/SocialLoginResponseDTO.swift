//
//  SocialLoginResponseDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/05.
//

import Foundation

struct SocialLoginResponseDTO: Codable {
    let code: String?
    let message: String?
    let timestamp: String?
    let accessToken: String?
    let accessTokenExpirationTime: String?
    let refreshToken: String?
    let refreshTokenExpirationTime: String?
}
