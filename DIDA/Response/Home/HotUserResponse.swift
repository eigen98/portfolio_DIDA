//
//  HotUserResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct HotUserResponse : Codable{
    var userId : Int
    var name : String
    var profileUrl : String
    var count : Int
    var followed : Bool
    var me : Bool
}
