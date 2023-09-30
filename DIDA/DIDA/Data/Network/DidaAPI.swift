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
    case soldout(range: Int)
    
    /// MARK: More
    case moreRecentNFT(page: Int, size: Int)
    case moreHotUser(page: Int)
    case moreSoldOut(range: Int, page: Int, size: Int)
    case moreHotActivity(page: Int, size: Int)
    
    /// MARK: Login
    case socialLogin(request: LoginRequestDTO)
    case signup(request: SignupRequestDTO)
    case duplicatedNickname(request: DuplicatedNicknameRequestDTO)
    
    /// MARK: Member
    case fetchMyself
    
    /// MARK: Market
    case nftDetail(nftId: Int)
}

extension DidaAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: SecretConstant.baseURL)!
    }
    
    var headers: [String: String]? {
        var defaultHeaders = ["Authorization" : Token.shared.accessToken ?? ""]
        switch self {
        case .socialLogin:
            defaultHeaders["Content-Type"] = "application/json; charset=utf-8"
        default:
            break
        }
        return defaultHeaders
    }
    
    var path: String {
        switch self {
        /// MARK: Home
        case .main: return "/main"
        case .soldout: return "/main/sold-out"
            
        /// MARK: More
        case .moreRecentNFT: return "/recent-nfts"
        case .moreHotUser(let page) : return "/hot/user/\(page)"
        case .moreSoldOut : return "/sold-outs"
        case .moreHotActivity: return "/hot-members"
        
        /// MARK: Login
        case .socialLogin(let request): return "/\(request.type.rawValue)/login"
        case .signup: return "/new/user"
        case .duplicatedNickname: return "/user/nickname"
        
        /// MARK: Member
        case .fetchMyself: return "/user"
            
        /// MARK: Market
        case .nftDetail(let nftId): return "/nft/\(nftId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        /// MARK: Home
        case .main: return .get
        case .soldout: return .get
            
        /// MARK: More
        case .moreRecentNFT: return .get
        case .moreHotUser : return .get
        case .moreSoldOut : return .get
        case .moreHotActivity: return .get
            
        /// MARK: Login
        case .socialLogin: return .post
        case .signup: return .post
        case .duplicatedNickname: return .post
        
        /// MARK: Member
        case .fetchMyself: return .get
            
        /// MARK: Market
        case .nftDetail: return .get
        }
    }
    
    var task: Task {
        switch self {
        /// MARK: Home
        case .main:
            return .requestPlain
        case .soldout(let range):
            return .requestParameters(parameters: ["range": range], encoding: URLEncoding.queryString)
        case .moreRecentNFT(let page, let size):
            return .requestParameters(parameters: ["page": page, "size" : size], encoding: URLEncoding.queryString)
        case .moreHotUser:
            return .requestPlain
        case .moreSoldOut(let range, let page, let size):
                    return .requestParameters(parameters: ["range": range, "page": page, "size": size],
                                              encoding: URLEncoding.queryString)
        case .moreHotActivity(let page, let size):
            return .requestParameters(parameters: ["page": page, "size": size],
                                      encoding: URLEncoding.queryString)
            
        /// MARK: Login
        case .socialLogin(let request):
                return .requestJSONEncodable(request)
        case .signup(let request):
            return .requestParameters(parameters: request.toDictionary ?? ["":""], encoding: JSONEncoding.default)
        case .duplicatedNickname(let request):
            return .requestParameters(parameters: request.toDictionary ?? ["":""], encoding: JSONEncoding.default)
        
        /// MARK: Member
        case .fetchMyself:
            return .requestPlain
        
        /// MARK: Market
        case .nftDetail: return .requestPlain
        }
    }
}
