//
//  HomeRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import RxSwift

class HomeRepositoryImpl: HomeRepository {
    
    let disposeBag = DisposeBag()
    
    func getMain() -> Single<GetMainResponse> {
        return APIClient.request(.main).map(GetMainResponse.self)
    }
    
    func getMainSoldout(term : String) -> Single<GetMainSoldoutNFTResponse> {
        return APIClient.request(.soldout(term: term)).map(GetMainSoldoutNFTResponse.self)
    }
}
