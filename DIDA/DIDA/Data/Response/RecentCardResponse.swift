//
//  RecentCardResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct PagedRecentCardResponse: Codable {
    var page: Int
    var pageSize: Int
    var hasNext: Bool
    var items: [RecentCardResponse]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pageSize
        case hasNext
        case items = "response"
    }
}

struct RecentCardResponse: Codable {
    var nftId: Int?
    var nftName: String?
    var memberName: String?
    var nftImgUrl: String?
    var price: String?
    var liked: Bool?
}
