//
//  DidaAPI.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation
import Moya
import RxSwift

enum DidaAPI {
    case main
    case soldout(term: String)
    case moreRecentNFT(page: Int)
}

extension DidaAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: SecretConstant.baseURL)!
    }
    
    var headers: [String: String]? {
        return ["Authorization" : ""]
    }
    
    var path: String {
        switch self {
        case .main: return "/main"
        case .soldout(let term): return "/main/\(term)"
        case .moreRecentNFT(let page) : return "/recent/card/\(page)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
}
