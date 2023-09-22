//
//  HotSellerResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
struct HotSellerResponse :Codable {
    var memberId: Int
    var memberName: String
    var profileUrl: String
    var nftImgUrl: String
}
