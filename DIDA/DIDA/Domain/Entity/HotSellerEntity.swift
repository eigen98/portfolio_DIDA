//
//  HotSellerEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

//HOT Seller
struct HotSellerEntity : Codable, Equatable{
    var userId : Int
    var sellerBacground :String
    var sellerProfile : String
    var sellerName : String
    
    static func == (lhs: HotSellerEntity, rhs: HotSellerEntity) -> Bool {
            return lhs.userId == rhs.userId
        }
    static func initLoadingEntity() -> HotSellerEntity{
        return HotSellerEntity(userId: -1, sellerBacground: "", sellerProfile: "", sellerName: "")
    }
}
