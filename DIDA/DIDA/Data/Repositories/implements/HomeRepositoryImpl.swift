//
//  HomeRepositoryImpl.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/20.
//

import Foundation
import RxSwift

class HomeRepositoryImpl: HomeRepository {
    
    private let disposeBag = DisposeBag()
    
    func getMain(completion: @escaping (Result<GetMainResponse, Error>) -> ()) {
        APIClient.request(.main)
            .map(GetMainResponse.self)
            .subscribe(onSuccess: { (response) in
                completion(.success(response))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
    
    func getMainSoldout(term: String, completion: @escaping (Result<[GetMainSoldoutNFTResponse], Error>) -> ()) {
        APIClient.request(.soldout(term: term))
            .map([GetMainSoldoutNFTResponse].self)
            .subscribe(onSuccess: { (response) in
                completion(.success(response))
            }, onFailure: { (error) in
                completion(.failure(error))
            }).disposed(by: disposeBag)
    }
}
