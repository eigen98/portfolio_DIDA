//
//  APIClient.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import Moya
import RxSwift

class APIClient<Target: TargetType>: MoyaProvider<Target> {
    
    init(plugins: [PluginType] = [NetworkLoggerPlugin()]) {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        super.init(session: session, plugins: plugins)
    }
    
    func request(_ target: Target) -> Single<Response> {
        return self.rx.request(target)
            .retry(2)
    }
}
