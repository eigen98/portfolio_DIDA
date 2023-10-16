//
//  MarketRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/29.
//

import Foundation
import RxSwift

class MarketRepositoryImpl: MarketRepository {
    
    private let disposeBag = DisposeBag()
    
    func getNFTDetail(nftId: Int, completion: @escaping (Result<GetNFTDetailResponse, Error>) -> ()) {
        APIClient.request(.nftDetail(nftId: nftId))
            .map(GetNFTDetailResponse.self)
            .subscribe(onSuccess: { (response) in
                completion(.success(response))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

    func purchaseNFT(payPwd: String, marketId: Int, completion: @escaping (Result<PurchaseNFTResponse, Error>) -> ()) {
           APIClient.request(.purchaseNFT(payPwd: payPwd, marketId: marketId))
               .map(PurchaseNFTResponse.self)
               .subscribe(onSuccess: { (response) in
                   completion(.success(response))
               }, onFailure: { (error) in
                   completion(.failure(error))
               }).disposed(by: disposeBag)
       }
}
