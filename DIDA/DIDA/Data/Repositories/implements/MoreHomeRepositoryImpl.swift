//
//  MoreHomeRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/24.
//

import Foundation
import RxSwift


class MoreHomeRepositoryImpl : MoreHomeRepository {
    let disposeBag = DisposeBag()

    func getMoreRecentNFT(page: Int, completion: @escaping (Result<PagedRecentCardResponse, Error>) -> ()) {
        APIClient.request(.moreRecentNFT(page: page, size: 6))
            .map(PagedRecentCardResponse.self)
            .subscribe(onSuccess: { (response) in
                completion(.success(response))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

    func getMoreHotActivity(page: Int, completion: @escaping (Result<[GetMoreActivityResponse], Error>) -> ()) {
        APIClient.request(.moreHotUser(page: page))
            .map([GetMoreActivityResponse].self)
            .subscribe(onSuccess: { (response) in
                completion(.success(response))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
    
    func getMoreSoldOut(range: Int, page: Int, size: Int, completion: @escaping (Result<GetMoreSoldOutResponse, Error>) -> ()) {
        APIClient.request(.moreSoldOut(range: range, page: page, size: size))
            .map(GetMoreSoldOutResponse.self)
            .subscribe(onSuccess: { (response) in
                completion(.success(response))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
}
