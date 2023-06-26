//
//  NFTEntity.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/06/05.
//

import Foundation

struct NFTEntity : Hashable{
    var cardId : Int
    var nickname : String
    var nftName : String
    var nftImg : String
    var heartCount : String
    var price : String
    var liked : Bool
    
    //로딩 객체
    static let loading = NFTEntity(cardId: -1, nickname: "Loading...", nftName: "Loading...", nftImg: "Loading...", heartCount: "Loading...", price: "Loading...", liked: false)
}
