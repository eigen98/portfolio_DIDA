//
//  HotUserEntity.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

//활발한 활동
struct HotUserEntity : Codable, Equatable{
    var userId : Int
    var name : String
    var profileUrl : String
    var count : Int
    var followed : Bool
    var me : Bool
    static func == (lhs: HotUserEntity, rhs: HotUserEntity) -> Bool {
            return lhs.userId == rhs.userId
        }
}
