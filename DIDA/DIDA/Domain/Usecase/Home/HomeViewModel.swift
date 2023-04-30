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
    
    struct Input {
        
    }
    
    struct Output{
        var homeOutput : BehaviorSubject<HomeEntity>
    }
    
    override init() {
        input = Input()
        output = Output(homeOutput: BehaviorSubject<HomeEntity>(value: HomeEntity(getHotItems: [],
                                                                                  getHotSellers: [],
                                                                                  getRecentCards: [],
                                                                                  getHotUsers: [])) )
        self.homeRepository = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    var input: Input
    var output: Output
    
    override func bind(){
        self.showLoading.accept(true) // Start loading
        
        self.homeRepository
            .getMain()
            .map{ response in
                response.toDomain()
            }
            .asObservable()
            .subscribe(onNext: { result in
                print("통신 결과 :  \(result)")
                self.output.homeOutput.onNext(result)
                
                
            }, onCompleted: {
                print("통신 완료")
                self.showLoading.accept(false) // Stop loading on completion
            })
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
}

