//
//  HotUserResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct HotUserResponse : Codable{
    var memberId : Int?
    var memberName : String?
    var profileUrl : String?
    var nftCount : Int?
    var followed : Bool?
    var me : Bool?
}
