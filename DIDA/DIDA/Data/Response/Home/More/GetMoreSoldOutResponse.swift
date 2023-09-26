//
//  GetMoreSoldOutResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/26.
//

import Foundation

struct GetMoreSoldOutResponse: Codable {
    let page: Int
    let pageSize: Int
    let hasNext: Bool
    let response: [SoldOutItem]
    
    struct SoldOutItem: Codable {
        let nftInfo: NFTInfo
        let memberInfo: MemberInfo
        
        struct NFTInfo: Codable {
            let nftId: Int
            let nftName: String
            let nftImgUrl: String
            let price: String
        }
        
        struct MemberInfo: Codable {
            let memberId: Int
            let memberName: String
            let profileImgUrl: String?
        }
    }
}

