//
//  MoreActivityEntity.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import Foundation
struct MoreActivityEntity: Hashable{
    var userId : Int
    var name : String
    var profileUrl : String
    var cardCnt : Int
    var cardUrls : [String]
    var followed : Bool
    
    static let loading = MoreActivityEntity(userId: -1,
                                            name: "Loading...",
                                            profileUrl: "Loading...",
                                            cardCnt: 0,
                                            cardUrls: ["Loading..."],
                                            followed: false)
}
