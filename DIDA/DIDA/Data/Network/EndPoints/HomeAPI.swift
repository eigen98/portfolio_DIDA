//
//  HomeAPI.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import Moya

//Home에서 사용할 API 엔드포인트를 정의
enum HomeAPI{
    case main
    case soldout(term: String)
}

extension HomeAPI : TargetType{
    var baseURL : URL{
        return URL(string: SecretConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .main: return "/main"
        case .soldout(let term): return "/main/\(term)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String: String]? {
        return ["Authorization" : ""]
    }
    
}
