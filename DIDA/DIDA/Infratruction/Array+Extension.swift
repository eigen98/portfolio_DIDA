//
//  Array+Extension.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

extension Array where Element == HotItemResponse {
    func toDomain() -> [NFTEntity] {
        return map {
            NFTEntity(
                cardId: $0.cardId ?? 0,
                nickname: $0.name ?? "",
                nftName: $0.name ?? "",
                nftImg: $0.imgUrl ?? "",
                heartCount: $0.count ?? "",
                price: $0.price ?? "",
                liked: false
            )
        }
    }
}


extension Array where Element == HotSellerResponse {
    func toDomain() -> [UserEntity] {
        return map {
            UserEntity(userId: $0.userId,
                       nickname: $0.name,
                       profileImage: $0.profileUrl,
                       description: "",
                       hasWallet: false,
                       cardCnt: 0,
                       followerCnt: 0,
                       followingCnt: 0
            )
        }
    }
}

extension Array where Element == RecentCardResponse {
    func toDomain() -> [NFTEntity] {
        return map {
            NFTEntity(
                cardId: $0.cardId ?? 0,
                nickname:  $0.userName ?? "",
                nftName: $0.cardName ?? "",
                nftImg: $0.imgUrl ?? "",
                heartCount: "",
                price:  $0.price ?? "",
                liked: $0.liked ?? false)
        }
    }
}
extension Array where Element == HotUserResponse {
    func toDomain() -> [UserEntity] {
        return map {
            UserEntity(
                userId: $0.userId ?? 0,
                nickname: $0.name ?? "",
                profileImage: $0.profileUrl ?? "",
                description: "",
                hasWallet: false,
                cardCnt: $0.count ?? 0,
                followerCnt: 0,
                followingCnt: 0
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
    func toDomain() -> [NFTEntity] {
        return map {
            NFTEntity(
                cardId: $0.nftId ?? 0,
                nickname: $0.userName ?? "",
                nftName: $0.name ?? "",
                nftImg:  $0.imgUrl ?? "",
                heartCount: "0",
                price: $0.price ?? "",
                liked: false
            )
        }
    }
}

