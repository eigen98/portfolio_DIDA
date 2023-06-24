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
    }
    
    struct Output{
        var homeOutput : BehaviorSubject<HomeEntity>
        
    }
    
    override init() {
        input = Input(refreshTrigger: PublishSubject<Void>())
        
        output = Output(homeOutput: BehaviorSubject<HomeEntity>(value: HomeEntity(getHotItems: [],
                                                                                  getHotSellers: [],
                                                                                  getRecentCards: [],
                                                                                  getHotUsers: [])))
        
        self.homeRepository = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    var input: Input
    var output: Output
    
    override func bind(){
        let refresh = input.refreshTrigger
                .flatMapLatest { [weak self] _ -> Observable<HomeEntity> in
                    guard let self = self else {
                        return Observable.empty()
                    }
                    return self.fetchHomeData()
                }
                .share()
            
            refresh
                .subscribe(onNext: {[weak self] result in
                    self?.output.homeOutput.onNext(result)
                })
                .disposed(by: disposeBag)
            
            input.refreshTrigger
                .map { _ in true }
                .bind(to: showLoading)
                .disposed(by: disposeBag)
            
        //MARK: 로딩 완료
            refresh
                .map { _ in false }
                .bind(to: showLoading)
                .disposed(by: disposeBag)

    }
    
    /*
     메인화면 데이터 가져오기
     */
    private func fetchHomeData() -> Observable<HomeEntity> {
        return self.homeRepository.getMain()
                .map { response in
                    response.toDomain()
                }
                .asObservable()
                .catch { error in
                    self.showError.onNext(error)
                    return Observable.empty()
                }
        }
  
}

