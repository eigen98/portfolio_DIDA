//
//  GetMainSoldoutResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct GetMainSoldoutNFTResponse: Codable {
    var nftAndMemberInfos: [NFTAndMemberInfo]?
    
    struct NFTAndMemberInfo: Codable {
        var nftInfo: NFTInfo?
        var memberInfo: MemberInfo?
    }
    
    struct NFTInfo: Codable {
        var nftId: Int?
        var nftName: String?
        var nftImgUrl: String?
        var price: String?
    }
    
    struct MemberInfo: Codable {
        var memberId: Int?
        var memberName: String?
        var profileImgUrl: String?
    }
}
