//
//  MoreHomeRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/24.
//

import Foundation
import RxSwift
class MoreHomeRepositoryImpl : MoreHomeRepository{
    
    let disposeBag = DisposeBag()
    
    func getMoreRecentNFT(page : Int) -> RxSwift.Single<[RecentCardResponse]> {
        APIClient.request(.moreRecentNFT(page: page)).map([RecentCardResponse].self)
    }
    
    
}
