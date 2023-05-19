//
//  DuplicatedNicknameRequestDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/07.
//

import Foundation

struct DuplicatedNicknameRequestDTO: Codable {
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
    }
}
