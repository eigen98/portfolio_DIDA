//
//  GetMainResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
//14. 메인화면 가져오기(판매완료없음) DTO
struct GetMainResponse : Codable{
    var getHotItems : [ItemEntity]
    var getHotSellers : [String]
    var getRecentCards : [String]
    var getHotUsers : [String]
}

//ENTITY
//TODO: Domain영역에 Entity디렉토리 만들어주시면 옮길예정
struct ItemEntity : Codable{
    var cardId : Int
    var imgUrl : String
    var name : String
}
