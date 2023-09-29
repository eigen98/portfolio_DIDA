//
//  GetNFTDetailResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/29.
//

import Foundation

struct GetNFTDetailResponse: Decodable {
    let nftInfo: NFTInfo?
    let description: String?
    let memberInfo: MemberInfo?
    let tokenId: String?
    let contractAddress: String?
    let followed: Bool?
    let liked: Bool?
    let isMe: Bool?
    
    struct NFTInfo: Decodable {
        let nftId: Int?
        let nftName: String?
        let nftImgUrl: String?
        let price: String?
    }
    
    struct MemberInfo: Decodable {
        let memberId: Int?
        let memberName: String?
        let profileImgUrl: String?
    }
    
    func toEntity() -> NFTDetailEntity {
        return NFTDetailEntity(
            nftId: nftInfo?.nftId ?? 0,
            nftName: nftInfo?.nftName ?? "",
            nftImgUrl: nftInfo?.nftImgUrl ?? "",
            price: nftInfo?.price ?? "",
            description: description ?? "",
            memberId: memberInfo?.memberId ?? 0,
            memberName: memberInfo?.memberName ?? "",
            profileImgUrl: memberInfo?.profileImgUrl ?? "",
            tokenId: tokenId ?? "",
            contractAddress: contractAddress ?? "",
            followed: followed ?? false,
            liked: liked ?? false,
            isMe: isMe ?? false
        )
    }

}
