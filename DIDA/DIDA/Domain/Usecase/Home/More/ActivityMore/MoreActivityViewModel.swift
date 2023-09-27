//
//  MoreActivityViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import Foundation
import RxSwift
import RxCocoa

class MoreActivityViewModel : BaseViewModel {
    var disposeBag: DisposeBag
    var input: Input
    var output: Output
    private let moreRepository: MoreHomeRepository
    
    struct Input {
        let refreshTrigger: PublishRelay<Void>
    }
    
    struct Output {
        var activityData: BehaviorSubject<[MoreActivityEntity]>
    }
    
    override init() {
        input = Input(refreshTrigger: PublishRelay<Void>())
        output = Output(activityData: BehaviorSubject<[MoreActivityEntity]>(value: []))
        disposeBag = DisposeBag()
        moreRepository = MoreHomeRepositoryImpl()
        super.init()
        bind()
    }
    
    override func bind() {
        super.bind()
        
        input.refreshTrigger
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(true)
            })
            .flatMapLatest { [weak self] _ in
                self?.getMoreActivityData() ?? Observable.empty()
            }
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(false)
            })
            .bind(onNext: { [weak self] data in
                self?.output.activityData.onNext(data)
            })
            .disposed(by: disposeBag)
    }
    
    private func getMoreActivityData() -> Observable<[MoreActivityEntity]> {
        return Observable.create { [weak self] observer in
            self?.moreRepository.getMoreHotActivity(page: 0) { result in
                switch result {
                case .success(let response):
                    let mappedEntities = response.response.toDomain()
                    observer.onNext(mappedEntities)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
