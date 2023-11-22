//
//  CoinTransactionRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/11/22.
//

import Foundation
import RxSwift

class CoinTransactionRepositoryImpl: CoinTransactionRepository {
    
    private let disposeBag = DisposeBag()

    func swapKlayToDida(payPwd: String, coin: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        APIClient.request(.swapKlayToDida(payPwd: payPwd, coin: coin))
            .map { response -> Bool in
                if response.statusCode == 200 {
                    return true
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    throw DidaError.apiError(error)
                }
            }
            .subscribe(onSuccess: { success in
                completion(.success(success))
            }, onFailure: { error in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }

    func swapDidaToKlay(payPwd: String, coin: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        APIClient.request(.swapDidaToKlay(payPwd: payPwd, coin: coin))
            .map { response -> Bool in
                if response.statusCode == 200 {
                    return true
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    throw DidaError.apiError(error)
                }
            }
            .subscribe(onSuccess: { success in
                completion(.success(success))
            }, onFailure: { error in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
}
