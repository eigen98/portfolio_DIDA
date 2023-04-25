//
//  GetMoreActivityResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import Foundation
//활발한 활동 더보기 DTO
struct GetMoreActivityResponse : Codable{
    var userId : Int
    var name : String
    var profileUrl : String
    var cardCnt : Int //var count : Int
    var cardUrls : [String]
    var followed : Bool
}
