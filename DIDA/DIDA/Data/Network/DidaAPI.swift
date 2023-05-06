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
    /// MARK: Home
    case main
    case soldout(term: String)
    case moreRecentNFT(page: Int)
    case moreHotUser(page: Int)
    
    /// MARK: Login
    case socialLogin(request: LoginRequestDTO)
    case signup(request: SignupRequestDTO)
}

extension DidaAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: SecretConstant.baseURL)!
    }
    
    var headers: [String: String]? {
        return ["Authorization" : UserSession.shared.accessToekn]
    }
    
    var path: String {
        switch self {
        /// MARK: Home
        case .main: return "/main"
        case .soldout(let term): return "/main/\(term)"
        case .moreRecentNFT(let page) : return "/recent/card/\(page)"
        case .moreHotUser(let page) : return "/hot/user/\(page)"
        
        /// MARK: Login
        case .socialLogin(let request): return "/\(request.type.rawValue)/login"
        case .signup: return "/new/user"
        }
    }
    
    var method: Moya.Method {
        switch self {
        /// MARK: Home
        case .main: return .get
        case .soldout: return .get
        case .moreRecentNFT: return .get
        case .moreHotUser: return .get
            
        /// MARK: Login
        case .socialLogin: return .post
        case .signup: return .post
        }
    }
    
    var task: Task {
        switch self {
        /// MARK: Home
        case .main:
            return .requestPlain
        case .soldout:
            return .requestPlain
        case .moreRecentNFT:
            return .requestPlain
        case .moreHotUser:
            return .requestPlain
            
        /// MARK: Login
        case .socialLogin(let request):
            return .requestParameters(parameters: request.toDictionary ?? ["":""], encoding: JSONEncoding.default)
        case .signup(let request):
            return .requestParameters(parameters: request.toDictionary ?? ["":""], encoding: JSONEncoding.default)
        }
    }
}
