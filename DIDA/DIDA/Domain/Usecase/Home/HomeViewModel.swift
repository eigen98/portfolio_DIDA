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
    
    struct Input {
        
    }
    struct Output{
        var homeOutput : BehaviorSubject<HomeEntity>
    }
    struct Dependency {
        let homeRepository : HomeRepository
    }
    
    init(dependency : Dependency) {
        
        input = Input()
        output = Output(homeOutput: BehaviorSubject<HomeEntity>(value: HomeEntity(getHotItems: [],
                                                                                  getHotSellers: [],
                                                                                  getRecentCards: [],
                                                                                  getHotUsers: [])) )
        self.dependency = dependency
        disposeBag = DisposeBag()
    }
    
    var input: Input
    var output: Output
    var dependency : Dependency
    
    override func bind(){
        dependency.homeRepository
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
            })
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
}

