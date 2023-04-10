//
//  HomeMapper.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation


extension GetMainResponse {
    func toDomain() -> HomeEntity {
        return HomeEntity(
            getHotItems: getHotItems.toDomain(),
            getHotSellers: getHotSellers.toDomain(),
            getRecentCards: getRecentCards.toDomain(),
            getHotUsers: getHotUsers.toDomain()
        )
    }
}


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
