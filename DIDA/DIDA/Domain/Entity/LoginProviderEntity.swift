//
//  LoginProviderEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

struct LoginProviderEntity: Codable {
    let idToken: String?
    let email: String?
    let isFirst: Bool
}
