//
//  HotItemResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct HotItemResponse : Codable{
    var cardId : Int
    var imgUrl : String
    var name : String
    var price : String
    var count : String
}
