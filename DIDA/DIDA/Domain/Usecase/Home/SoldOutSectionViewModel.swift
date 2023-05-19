//
//  SoldOutSectionViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/05/02.
//

import Foundation
import RxSwift

class SoldOutSectionViewModel : BaseViewModel{
    
    private var disposeBag : DisposeBag
    private let homeRepository: HomeRepository
    private var isLoadingNextPage: Bool = false
    
    var input: Input
    var output: Output
    
    struct Input {
        let refreshTrigger: PublishSubject<String>
    }
    
    struct Output{
        var soldoutOutput : BehaviorSubject<[UserNftEntity]>
        var isLoading: BehaviorSubject<Bool>
        var isRefreshing: BehaviorSubject<Bool>
    }
    
    
    override init() {
        input = Input(refreshTrigger: PublishSubject<String>())
        
        output = Output(soldoutOutput: BehaviorSubject<[UserNftEntity]>(value: []),
        
                        isLoading: BehaviorSubject<Bool>(value: false),
                        isRefreshing: BehaviorSubject<Bool>(value: false))
        
        self.homeRepository = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    override func bind(){
        
        let refresh = input.refreshTrigger
                    .flatMapLatest { term in
                        self.homeRepository
                            .getMainSoldout(term: "\(term)" )
                            .map { response in
                                response.toDomain()
                            }
                    }
                    .share()
        
        //loadNextPage와 refresh Observable이 반환하는 결과를 합쳐서 soldoutOutput 반영
        //페이징 및 리프레시 작업이 완료될 때마다 업데이트
        Observable.merge( refresh)
                   .subscribe(onNext: { result in
                       //print("통신 결과 :  \(result)")
                       print("통신")
                       self.output.soldoutOutput.onNext(result)
                   })
                   .disposed(by: disposeBag)
        
        
        input.refreshTrigger
            .map { _ in true }
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
        
        refresh
            .map { _ in false }
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    
}
