//
//  MoreHomeRepository.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/24.
//

import Foundation
import RxSwift
import RxCocoa

//홈 더보기 레포지토리
protocol MoreHomeRepository{
    //40 최근 NFT 더보기
    func getMoreRecentNFT(page : Int) -> Single<[RecentCardResponse]> //  Single<Result<GetMainResponse, NetworkError>>
    
}
