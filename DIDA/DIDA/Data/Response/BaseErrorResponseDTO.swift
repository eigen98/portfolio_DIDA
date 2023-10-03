//
//  BaseErrorResponseDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/07.
//

import Foundation

struct BaseErrorResponseDTO: Codable {
    let timestamp: String?
    let status: Int?
    let error: String?
    let path: String?
    let message: String?
    let code: String?
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case status
        case error
        case path
        case message
        case code
    }
    
    // {"timestamp":"2023-05-06T15:39:09.177+00:00","status":500,"error":"Internal Server Error","path":"/kakao/login"}
    
    /* { "timestamp": "2022-05-28T17:35:47.256789",
    "status": 400,
    "message": "사용할 수 없는 닉네임 입니다.",
    "code": 109
    } */
}
