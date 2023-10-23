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
}
