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
    
    //로딩 객체
    static let loading = UserEntity(userId: -1, nickname: "Loading...", profileImage: nil, description: "Loading...", hasWallet: false, cardCnt: 0, followerCnt: 0, followingCnt: 0)
}
