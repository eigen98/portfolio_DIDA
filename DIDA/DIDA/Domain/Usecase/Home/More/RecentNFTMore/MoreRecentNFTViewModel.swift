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

    struct Input {
        let refreshTrigger: PublishRelay<Void>
    }

    struct Output {
        var recentNFTData: BehaviorSubject<[NFTEntity]>
    }

    override init() {
        input = Input(refreshTrigger: PublishRelay<Void>())
        output = Output(recentNFTData: BehaviorSubject<[NFTEntity]>(value: []))
        disposeBag = DisposeBag()
        moreRepository = MoreHomeRepositoryImpl()
    }

    override func bind() {
        super.bind()
        
        input.refreshTrigger
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(true)
            })
            .flatMapLatest { [weak self] _ in
                self?.getRecentNFTData() ?? Observable.empty()
            }
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(false)
            })
            .bind(onNext: { [weak self] data in
                self?.output.recentNFTData.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func getRecentNFTData() -> Observable<[NFTEntity]> {
        return Observable.create { [weak self] observer in
            self?.moreRepository.getMoreRecentNFT(page: 0) { result in
                switch result {
                case .success(let response):
                    let mappedEntities = response.items.toDomain()
                    observer.onNext(mappedEntities)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

