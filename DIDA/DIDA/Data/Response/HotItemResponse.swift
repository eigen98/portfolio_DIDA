//
//  HotItemResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct HotItemResponse : Codable{
    var nftId : Int?
    var nftImgUrl : String?
    var nftName : String?
    var price : String?
    var likeCount : String?
}
