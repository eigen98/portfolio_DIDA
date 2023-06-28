//
//  MoreActivityViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import Foundation
import RxSwift
import RxCocoa

//class MoreActivityViewModel : BaseViewModel{
//    var disposeBag : DisposeBag
//    var input: Input
//    var output: Output
//    private let moreRepository: MoreHomeRepository
//
//    struct Input {
//
//    }
//
//    struct Output{
//        var activityData : BehaviorSubject<[MoreActivityEntity]>
//    }
//
//    override init() {
//        input = Input()
//        output = Output(activityData: BehaviorSubject<[MoreActivityEntity]>(value: []))
//        disposeBag = DisposeBag()
//        moreRepository = MoreHomeRepositoryImpl()
//    }
//
//
//    override func bind() {
//        moreRepository.getMoreHotActivity(page: 0)
//            .map{
//                $0.toDomain()
//            }
//            .asObservable()
//            .bind(onNext: { [weak self] result in
//                    guard let `self` = self else { return }
//                self.output.activityData.onNext(result)
//            }).disposed(by: disposeBag)
//    }
//}

class MoreActivityViewModel : BaseViewModel {
    var disposeBag : DisposeBag
    var input: Input
    var output: Output
    private let moreRepository: MoreHomeRepository

    struct Input {}

    struct Output {
        var activityData: BehaviorSubject<[MoreActivityEntity]>
    }

    override init() {
        input = Input()
        output = Output(activityData: BehaviorSubject<[MoreActivityEntity]>(value: []))
        disposeBag = DisposeBag()
        moreRepository = MoreHomeRepositoryImpl()
    }

    override func bind() {
        super.bind()
        
        moreRepository.getMoreHotActivity(page: 0) { [weak self] result in
            switch result {
            case .success(let response):
                let mappedEntities = response.toDomain()
                self?.output.activityData.onNext(mappedEntities)
            case .failure(let error):
              
                print(error.localizedDescription)
            }
        }
    }
}
