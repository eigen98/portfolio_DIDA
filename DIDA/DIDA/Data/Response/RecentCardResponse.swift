//
//  RecentCardResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct RecentCardResponse: Codable{
    var nftId : Int?
    var nftName : String?
    var memberName : String?
    var nftImgUrl : String?
    var price : String?
    var liked : Bool?
    
}
