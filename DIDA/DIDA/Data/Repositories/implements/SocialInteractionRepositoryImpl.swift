//
//  SocialInteractionRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/01.
//

import Foundation
import RxSwift

class SocialInteractionRepositoryImpl: SocialInteractionRepository {
    
    private let disposeBag = DisposeBag()
    
    func likeNFT(nftId: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        APIClient.request(.likeNFT(nftId: nftId))
            .map { response -> Bool in
                if response.statusCode == 200 {
                    return true
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    throw DidaError.apiError(error)
                }
            }
            .subscribe(onSuccess: { (success) in
                completion(.success(success))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
    
    func followUser(memberId: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        APIClient.request(.followMember(memberId: memberId))
            .map { response -> Bool in
                if response.statusCode == 200 {
                    return true
                } else {
                    let error = try response.map(BaseErrorResponseDTO.self)
                    throw DidaError.apiError(error)
                }
            }
            .subscribe(onSuccess: { (success) in
                completion(.success(success))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
}
