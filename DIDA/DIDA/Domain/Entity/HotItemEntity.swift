//
//  HotItemEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

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
