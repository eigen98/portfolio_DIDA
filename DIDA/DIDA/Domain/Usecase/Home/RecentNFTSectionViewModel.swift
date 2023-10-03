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
    private var repository : SocialInteractionRepository
    private var disposeBag = DisposeBag()
    
    override init() {
        let itemsSubject = BehaviorSubject<[NFTEntity]>(value: [])
        let likeStatusChangedSubject = PublishSubject<(Bool, Int)>()
        
        self.input = Input(likeButtonTapped: PublishRelay(), moreButtonTapped: PublishRelay())
        self.output = Output(items: itemsSubject, likeStatusChanged: likeStatusChangedSubject)
        repository = SocialInteractionRepositoryImpl()
        super.init()
        
    }
    
    override func bind() {
        input.likeButtonTapped.subscribe(onNext: { [weak self] index in
            self?.toggleLikeStatus(at: index)
        }).disposed(by: disposeBag)
    }
    
    private func toggleLikeStatus(at index: Int) {
        guard var items = try? output.items.value() else { return }
        items[index].liked.toggle()
        output.items.onNext(items)
        output.likeStatusChanged.onNext((items[index].liked, index))
        
        performLikeAction(for: items[index])
    }
    
    private func performLikeAction(for item: NFTEntity) {
        repository.likeNFT(nftId: item.cardId) { [weak self] result in
            switch result {
            case .success(let success):
                if !success {
                    self?.revertLikeStatus(for: item.cardId)
                }
            case .failure(let error):
                self?.revertLikeStatus(for: item.cardId)
                print("Error liking NFT: \(error)")
            }
        }
    }
    private func revertLikeStatus(for cardId: Int) {
        guard var items = try? output.items.value(),
              let index = items.firstIndex(where: { $0.cardId == cardId }) else { return }
        
        items[index].liked.toggle()
        output.items.onNext(items)
        output.likeStatusChanged.onNext((items[index].liked, index))
    }
    
    func configure(items: [NFTEntity]) {
        output.items.onNext(items)
    }
}
