//
//  HomeRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import RxSwift
class HomeRepositoryImpl : HomeRepository{
    
    let apiClient : APIClient<HomeAPI>
    
    init(apiClient: APIClient<HomeAPI>) {
        self.apiClient = apiClient
    }
    //14 메인 화면 가져오기(판매완료 없음)
    func getMain() -> Single<GetMainResponse> { //  Single<Result<GetMainResponse, NetworkError>>
        return apiClient.request(.main)
            .map(GetMainResponse.self)
            .debug()
        
    }
    //15. 홈화면 판매 완료 메인화면 가져오기
    func getMainSoldout(term : String) -> Single<GetMainSoldoutNFTResponse> {
        return apiClient.request(.soldout(term: term))
            .map(GetMainSoldoutNFTResponse.self)
            .debug()
    }
    
}
