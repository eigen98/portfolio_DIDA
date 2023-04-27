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
    //최신 NFT 더보기
    func getMoreRecentNFT(page : Int) -> RxSwift.Single<[RecentCardResponse]> {
        APIClient.request(.moreRecentNFT(page: page)).map([RecentCardResponse].self)
    }
    
    //활발한 활동 더보기
    func getMoreHotActivity(page: Int) -> RxSwift.Single<[GetMoreActivityResponse]> {
        APIClient.request(.moreHotUser(page: page)).map([GetMoreActivityResponse].self)
    }
    
    
}
