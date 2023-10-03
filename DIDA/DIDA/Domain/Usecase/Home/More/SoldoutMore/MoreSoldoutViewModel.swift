//
//  MoreSoldoutViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/25.
//

import Foundation
import RxSwift
import RxCocoa

class MoreSoldoutViewModel: BaseViewModel {
    
    struct Input {
        let refreshTrigger: PublishSubject<Void>
        let rangeTrigger: PublishSubject<Int>
    }
    
    struct Output {
        var soldoutNFTData: BehaviorSubject<[NFTEntity]>
    }
    
    var input: Input
    var output: Output
    
    private var disposeBag: DisposeBag
    private let moreRepository: MoreHomeRepository
    
    override init() {
        input = Input(refreshTrigger: PublishSubject<Void>(),
                      rangeTrigger: PublishSubject<Int>())
        output = Output(soldoutNFTData: BehaviorSubject<[NFTEntity]>(value: []))
        disposeBag = DisposeBag()
        moreRepository = MoreHomeRepositoryImpl()
    }
    
    override func bind() {

        Observable
                .combineLatest(input.refreshTrigger, input.rangeTrigger.startWith(7))
                .do(onNext: { [weak self] _, range in
                    self?.showLoading.accept(true)
                })
                .flatMapLatest { [weak self] _, range in
                    return self?.getSoldoutNFTData(range: range, page: 0) ?? Observable.empty()
                }
                .do(onNext: { [weak self] _ in
                    self?.showLoading.accept(false)
                })
                .bind(onNext: { [weak self] data in
                    self?.output.soldoutNFTData.onNext(data)
                })
                .disposed(by: disposeBag)
                       
    }

    private func getSoldoutNFTData(range: Int, page: Int) -> Observable<[NFTEntity]> {
        return Observable.create { [weak self] observer in
            self?.moreRepository.getMoreSoldOut(range: range, page: page) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response.toDomain())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
