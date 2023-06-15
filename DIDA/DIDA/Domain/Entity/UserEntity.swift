//
//  UserEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

struct UserEntity : Hashable {
    let userId: Int
    let nickname: String?
    let profileImage: String?
    let description: String?
    
    let hasWallet: Bool
    let cardCnt: Int
    
    let followerCnt: Int
    let followingCnt: Int
}
