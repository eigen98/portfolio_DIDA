//
//  ActivitySectionViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa

class ActivitySectionViewModel : BaseViewModel{
    
    private var disposeBag : DisposeBag
    private var homeRepsitory : HomeRepository
    
    var input : Input
    var output : Output
    
    struct Input{
        let followButtonTapped: PublishRelay<(Bool, Int)>
            
    }
    struct Output{
        let followStatusChanged: Observable<(Bool, Int)>
    }
    
    override init(){
        input = Input(followButtonTapped: PublishRelay<(Bool,Int)>())
        output = Output(followStatusChanged: input.followButtonTapped.asObservable())
        homeRepsitory = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    override func bind() {
        output.followStatusChanged
            .subscribe(onNext: {[weak self] isFollowing, buttonIndex in
                self?.updateFollowStatus(isFollowing: isFollowing, buttonIndex: buttonIndex)
            })
            .disposed(by: disposeBag)
    }
    private func updateFollowStatus(isFollowing : Bool, buttonIndex : Int){
        
    }
    
    
    
}
