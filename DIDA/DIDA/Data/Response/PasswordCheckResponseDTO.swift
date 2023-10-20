//
//  PasswordCheckResponseDTO.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/20.
//

import Foundation

struct PasswordCheckResponseDTO: Codable {
    let matched: Bool?
    let wrongCnt: Int?
}
