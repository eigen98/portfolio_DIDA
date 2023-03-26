//
//  GetMainResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
//14. 메인화면 가져오기(판매완료없음) DTO
struct GetMainResponse : Codable{
    var getHotItems : [HotItemResponse]
    var getHotSellers : [HotSellerResponse]
    var getRecentCards : [RecentCardResponse]
    var getHotUsers : [HotUserResponse]
}



// Entity
//TODO: Domain Entity 디렉토리 생성시 옮길 예정
struct HomeEntity{
    var getHotItems : [HotItemEntity]
    var getHotSellers : [HotSellerEntity]
    var getRecentCards : [UserNftEntity]
    var getHotUsers : [HotUserEntity]
}
// HOT Item 🔥
struct HotItemEntity : Codable, Equatable{
    var cardId : Int
    var nftImg : String
    var nftName : String
    var heartCount : String
    var price : String
    
    static func == (lhs: HotItemEntity, rhs: HotItemEntity) -> Bool {
            return lhs.cardId == rhs.cardId
        }
}

//HOT Seller
struct HotSellerEntity : Codable, Equatable{
    var userId : Int
    var sellerBacground :String
    var sellerProfile : String
    var sellerName : String
    
    static func == (lhs: HotSellerEntity, rhs: HotSellerEntity) -> Bool {
            return lhs.userId == rhs.userId
        }
}
//최신 NFT
struct UserNftEntity : Codable, Equatable {
    var cardId : Int
    var userName : String
    var cardName : String
    var imgUrl : String
    var price : String
    var liked : Bool
    
    static func == (lhs: UserNftEntity, rhs: UserNftEntity) -> Bool {
            return lhs.cardId == rhs.cardId
        }
}
//활발한 활동
struct HotUserEntity : Codable, Equatable{
    var userId : Int
    var name : String
    var profileUrl : String
    var count : Int
    var followed : Bool
    var me : Bool
    static func == (lhs: HotUserEntity, rhs: HotUserEntity) -> Bool {
            return lhs.userId == rhs.userId
        }
}
