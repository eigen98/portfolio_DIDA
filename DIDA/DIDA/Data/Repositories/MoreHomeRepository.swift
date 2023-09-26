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
protocol MoreHomeRepository {
    //40 최근 NFT 더보기
    func getMoreRecentNFT(page: Int, completion: @escaping (Result<PagedRecentCardResponse, Error>) -> ())
    
    func getMoreHotActivity(page: Int, completion: @escaping (Result<[GetMoreActivityResponse], Error>) -> ())
    
    func getMoreSoldOut(range: Int, page: Int, completion: @escaping (Result<GetMoreSoldOutResponse, Error>) -> ())
}
