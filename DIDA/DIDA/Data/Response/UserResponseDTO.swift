//
//  UserResponseDTO.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/05.
//

import Foundation

struct UserResponseDTO: Codable {
    
    let userId: Int?
    let nickname: String?
    let profileUrl: String?
    let description: String?
    
    let getWallet: Bool?
    let cardCnt: Int?
    
    let followerCnt: Int?
    let followingCnt: Int?
    
    enum CodingKey {
        case userId
        case nickname
        case profileUrl
        case description
        case getWallet
        case cardCnt
        case followerCnt
        case followingCnt
    }
}
