//
//  LoginProviderEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

struct LoginProviderEntity: Codable {
    var email: String? = nil
    var nickname: String? = nil
    let isFirst: Bool
}
