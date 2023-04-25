//
//  GetMainResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
//14. 메인화면 가져오기(판매완료없음) DTO
struct GetMainResponse : Codable {
    var getHotItems : [HotItemResponse]
    var getHotSellers : [HotSellerResponse]
    var getRecentCards : [RecentCardResponse]
    var getHotUsers : [HotUserResponse]
    
    func toDomain() -> HomeEntity {
        return HomeEntity(
            getHotItems: getHotItems.toDomain(),
            getHotSellers: getHotSellers.toDomain(),
            getRecentCards: getRecentCards.toDomain(),
            getHotUsers: getHotUsers.toDomain()
        )
    }
}
