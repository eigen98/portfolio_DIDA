//
//  APIClient.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import Moya
import RxSwift

class APIClient: MoyaProvider<DidaAPI> {
    
    static let shared = APIClient()
    
    private init(plugins: [PluginType] = [NetworkLoggerPlugin()]) {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        super.init(session: session, plugins: plugins)
    }
    
    static func request(_ target: Target) -> Single<Response> {
        return APIClient.shared.rx.request(target)
            .retry(2)
    }
}
