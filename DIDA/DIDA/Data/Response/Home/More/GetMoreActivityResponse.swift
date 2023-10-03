//
//  GetMoreActivityResponse.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import Foundation
//활발한 활동 더보기 DTO
struct GetMoreActivityResponse: Codable {
    var page: Int
    var pageSize: Int
    var hasNext: Bool
    var response: [ActivityResponse]
}

struct ActivityResponse: Codable {
    var memberInfo: MemberInfo
    var nftImgUrl: [String]
}

struct MemberInfo: Codable {
    var memberId: Int
    var memberName: String
    var profileUrl: String?
    var nftCount: Int
    var followed: Bool
    var me: Bool
}
