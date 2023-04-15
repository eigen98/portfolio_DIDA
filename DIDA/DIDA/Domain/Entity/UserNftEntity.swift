//
//  UserNftEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

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
