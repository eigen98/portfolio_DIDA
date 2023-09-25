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
                cardId: $0.nftId ?? 0,
                nickname: $0.nftName ?? "",
                nftName: $0.nftName ?? "",
                nftImg: $0.nftImgUrl ?? "",
                heartCount: $0.likeCount ?? "",
                price: $0.price ?? "",
                liked: false
            )
        }
    }
}


extension Array where Element == HotSellerResponse {
    func toDomain() -> [UserEntity] {
        return map {
            UserEntity(userId: $0.memberId,
                       nickname: $0.memberName,
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
                cardId: $0.nftId ?? 0,
                nickname:  $0.memberName ?? "",
                nftName: $0.nftName ?? "",
                nftImg: $0.nftImgUrl ?? "",
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
                userId: $0.memberId ?? 0,
                nickname: $0.memberName ?? "",
                profileImage: $0.profileUrl ?? "",
                description: "",
                hasWallet: false,
                cardCnt: $0.nftCount ?? 0,
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

extension Array where Element == GetMainSoldoutNFTResponse.NFTAndMemberInfo {
    func toDomain() -> [NFTEntity] {
        return map {
            NFTEntity(
                cardId: $0.nftInfo?.nftId ?? 0,
                nickname: $0.memberInfo?.memberName ?? "",
                nftName: $0.nftInfo?.nftName ?? "",
                nftImg: $0.nftInfo?.nftImgUrl ?? "",
                heartCount: "0",
                price: $0.nftInfo?.price ?? "",
                liked: false
            )
        }
    }
}


