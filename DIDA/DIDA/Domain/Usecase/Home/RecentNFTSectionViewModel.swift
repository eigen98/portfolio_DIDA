//
//  RecentNFTSectionViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/01.
//

import RxSwift
import RxCocoa

class RecentNFTSectionViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        let likeButtonTapped: PublishRelay<Int>
        let moreButtonTapped: PublishRelay<Void>
    }
    
    struct Output {
        let items: BehaviorSubject<[NFTEntity]>
        let likeStatusChanged: PublishSubject<(Bool, Int)>
    }
    
    private var disposeBag = DisposeBag()
    
    override init() {
        let itemsSubject = BehaviorSubject<[NFTEntity]>(value: [])
        let likeStatusChangedSubject = PublishSubject<(Bool, Int)>()
        
        self.input = Input(likeButtonTapped: PublishRelay(), moreButtonTapped: PublishRelay())
        self.output = Output(items: itemsSubject, likeStatusChanged: likeStatusChangedSubject)
        
        super.init()
        
    }
    
    override func bind() {
        input.likeButtonTapped.subscribe(onNext: { [weak self] index in
            guard var viewModels = try? self?.output.items.value() else { return }
            viewModels[index].liked.toggle()
            self?.output.items.onNext(viewModels)
            self?.output.likeStatusChanged.onNext((viewModels[index].liked, index))
        }).disposed(by: disposeBag)
        
    }
    
    func configure(items: [NFTEntity]) {
        output.items.onNext(items)
    }
}
