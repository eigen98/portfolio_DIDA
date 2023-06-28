//
//  MoreRecentNFTViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/24.
//

import Foundation
import RxSwift
import RxCocoa


class MoreRecentNFTViewModel : BaseViewModel {
    var disposeBag : DisposeBag
    var input: Input
    var output: Output
    private let moreRepository: MoreHomeRepository

    struct Input {}

    struct Output {
        var recentNFTData: BehaviorSubject<[NFTEntity]>
    }

    override init() {
        input = Input()
        output = Output(recentNFTData: BehaviorSubject<[NFTEntity]>(value: []))
        disposeBag = DisposeBag()
        moreRepository = MoreHomeRepositoryImpl()
    }

    override func bind() {
        super.bind()
        
        moreRepository.getMoreRecentNFT(page: 0) { [weak self] result in
            switch result {
            case .success(let response):
                let mappedEntities = response.toDomain()
                self?.output.recentNFTData.onNext(mappedEntities)
            case .failure(let error):
               
                print(error.localizedDescription)
            }
        }
    }
}

