//
//  Array+Extension.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

extension Array where Element == HotItemResponse {
    func toDomain() -> [HotItemEntity] {
        return map {
            HotItemEntity(
                cardId: $0.cardId,
                nftImg: $0.imgUrl,
                nftName: $0.name,
                heartCount: $0.count,
                price: $0.price
            )
        }
    }
}


extension Array where Element == HotSellerResponse {
    func toDomain() -> [HotSellerEntity] {
        return map {
            HotSellerEntity(
                userId: $0.userId,
                sellerBacground: $0.imgUrl,
                sellerProfile: $0.profileUrl,
                sellerName: $0.name
            )
        }
    }
}

extension Array where Element == RecentCardResponse {
    func toDomain() -> [UserNftEntity] {
        return map {
            UserNftEntity(
                cardId: $0.cardId,
                userName: $0.userName,
                cardName: $0.cardName,
                imgUrl: $0.imgUrl,
                price: $0.price,
                liked: $0.liked
            )
        }
    }
}
extension Array where Element == HotUserResponse {
    func toDomain() -> [HotUserEntity] {
        return map {
            HotUserEntity(
                userId: $0.userId,
                name: $0.name,
                profileUrl: $0.profileUrl,
                count: $0.count,
                followed: $0.followed,
                me: $0.me
            )
        }
    }
}

extension Array where Element == GetMoreActivityResponse {
    func toDomain() -> [MoreActivityEntity] {
        return map {
            MoreActivityEntity(
                userId: $0.userId,
                name: $0.name,
                profileUrl: $0.profileUrl,
                cardCnt: $0.cardCnt,
                cardUrls: $0.cardUrls,
                followed : $0.followed
            )
        }
    }
}

extension Array where Element == GetMainSoldoutNFTResponse{
    func toDomain() -> [UserNftEntity] {
        return map {
            UserNftEntity(
                cardId: $0.nftId,
                userName: $0.userName,
                cardName: $0.name,
                imgUrl: $0.imgUrl,
                price: $0.price,
                liked : false
            )
        }
    }
}

