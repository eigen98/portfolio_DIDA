//
//  RecentCardResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct RecentCardResponse: Codable{
    var cardId : Int
    var cardName : String
    var userName : String
    var imgUrl : String
    var price : String
    var liked : Bool
    
}
