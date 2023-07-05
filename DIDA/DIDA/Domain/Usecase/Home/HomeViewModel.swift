//
//  HomeViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/19.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel : BaseViewModel {
    
    private var disposeBag : DisposeBag
    
    private let homeRepository: HomeRepository
    private var isLoadingNextPage: Bool = false
    struct Input {
        let refreshTrigger: PublishSubject<Void>
    }
    
    struct Output {
        var homeOutput : BehaviorSubject<Result<HomeEntity, Error>>
    }
    
    override init() {
        input = Input(refreshTrigger: PublishSubject<Void>())
        
        output = Output(homeOutput: BehaviorSubject<Result<HomeEntity, Error>>(value: .success(HomeEntity(getHotItems: [],
                                                                                                           getHotSellers: [],
                                                                                                           getRecentCards: [],
                                                                                                           getHotUsers: []))))
        
        self.homeRepository = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    var input: Input
    var output: Output
    
    override func bind() {
        input.refreshTrigger
               .do(onNext: { [weak self] _ in
                   print("로딩 시작")
                   self?.showLoading.accept(true)
               })
               .flatMapLatest { [weak self] _ in
                   self?.fetchHomeData() ?? Observable.empty()
               }
               .do(onNext: { [weak self] _ in
                   
                   self?.showLoading.accept(false)
               })
               .bind(to: output.homeOutput)
               .disposed(by: disposeBag)
    }
    
    /*
     메인화면 데이터 가져오기
     */
    private func fetchHomeData() -> Observable<Result<HomeEntity, Error>> {
        return Observable.create { [weak self] observer in
            self?.homeRepository.getMain() { result in
                switch result {
                case .success(let response):
                    let homeEntity = response.toDomain()
                    observer.onNext(.success(homeEntity))
                    
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
