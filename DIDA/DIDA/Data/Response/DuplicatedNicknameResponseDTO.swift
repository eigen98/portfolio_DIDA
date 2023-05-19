//
//  DuplicatedNicknameResponseDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/07.
//

import Foundation

struct DuplicatedNicknameResponseDTO: Codable {
    let used: Bool?
    
    enum CodingKeys: String, CodingKey {
        case used
    }
}
