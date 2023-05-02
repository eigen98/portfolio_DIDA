//
//  HomeViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel : BaseViewModel{
    
    private var disposeBag : DisposeBag
    
    private let homeRepository: HomeRepository
    private var isLoadingNextPage: Bool = false
    struct Input {
        let refreshTrigger: PublishSubject<Void>
        let loadNextPageTrigger: PublishSubject<Void>
    }
    
    struct Output{
        var homeOutput : BehaviorSubject<HomeEntity>
        var isLoading: BehaviorSubject<Bool>
        var isRefreshing: BehaviorSubject<Bool>
    }
    
    override init() {
        input = Input(refreshTrigger: PublishSubject<Void>(),
                      loadNextPageTrigger: PublishSubject<Void>())
        
        output = Output(homeOutput: BehaviorSubject<HomeEntity>(value: HomeEntity(getHotItems: [],
                                                                                  getHotSellers: [],
                                                                                  getRecentCards: [],
                                                                                  getHotUsers: [])),
        
                        isLoading: BehaviorSubject<Bool>(value: false),
                        isRefreshing: BehaviorSubject<Bool>(value: false))
        
        self.homeRepository = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    var input: Input
    var output: Output
    
    override func bind(){
        
        let loadNextPage = input.loadNextPageTrigger
                   .filter { !self.isLoadingNextPage }
                   .do(onNext: { self.isLoadingNextPage = true })
                   .flatMapLatest { _ in
                       self.homeRepository
                           .getMain()
                           .map { response in
                               response.toDomain()
                           }
                   }
                   .do(onNext: { _ in
                       self.isLoadingNextPage = false
                   })
                   .share()
        
        let refresh = input.refreshTrigger
                    .flatMapLatest { _ in
                        self.homeRepository
                            .getMain()
                            .map { response in
                                response.toDomain()
                            }
                    }
                    .share()
        
        //loadNextPage와 refresh Observable이 반환하는 결과를 합쳐서 homeOutput 반영
        //페이징 및 리프레시 작업이 완료될 때마다 업데이트
        Observable.merge(loadNextPage, refresh)
                   .subscribe(onNext: { result in
                       //print("통신 결과 :  \(result)")
                       print("통신")
                       self.output.homeOutput.onNext(result)
                   })
                   .disposed(by: disposeBag)
        
        input.loadNextPageTrigger
            .map { _ in true }
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
        
        
        input.refreshTrigger
            .map { _ in true }
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
        
        loadNextPage
            .map { _ in false }
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
        
        refresh
            .map { _ in false }
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    
    
    
}

