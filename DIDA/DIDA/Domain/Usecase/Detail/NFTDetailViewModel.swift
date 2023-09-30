//
//  NFTDetailViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import RxSwift
import RxCocoa

class NFTDetailViewModel: BaseViewModel {
    var disposeBag: DisposeBag
    var input: Input
    var output: Output
    private let marketRepository: MarketRepository
    
    enum SectionItem {
        case overview(OverviewData?)
        case detailInfo(DetailInfoData?)
        case community(CommunityData?)
    }

    
    struct Input {
        let refreshTrigger: PublishRelay<Int>
    }

    
    struct Output {
        var nftDetailData: BehaviorSubject<[SectionItem]>
        var priceObservable: BehaviorSubject<String?>
    }
    
    init(marketRepository: MarketRepository = MarketRepositoryImpl()) {
        self.marketRepository = marketRepository
        input = Input(refreshTrigger: PublishRelay<Int>())
        output = Output(nftDetailData: BehaviorSubject<[SectionItem]>(value: [
            .community(nil),
            .detailInfo(nil),
            .overview(nil)]),
                        priceObservable: BehaviorSubject<String?>(value: nil))
        disposeBag = DisposeBag()
        super.init()
        bind()
    }
    
    override func bind() {
        super.bind()
        
        input.refreshTrigger
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(true)
            })
            .flatMapLatest { [weak self] _ -> Observable<NFTDetailEntity> in
                guard let self = self else { return Observable.empty() }
                return self.getNFTDetailData()
                
            }
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(false)
            })
            .map { [weak self] entity -> [SectionItem] in
                return self?.convertEntityToViewModel(entity: entity) ?? []
            }
            .bind(to: output.nftDetailData)
            .disposed(by: disposeBag)
        
        output.nftDetailData
            .map { sectionItems in
                sectionItems.compactMap { item -> String? in
                    if case let .detailInfo(detailInfoData) = item {
                        return detailInfoData?.price
                    }
                    return nil
                }.first
            }
            .subscribe(onNext: { [weak self] price in
                self?.output.priceObservable.onNext(price)
            })
            .disposed(by: disposeBag)
    }
    
    private func convertEntityToViewModel(entity: NFTDetailEntity) -> [SectionItem] {
        let overviewData = OverviewData(nftImageUrl: entity.nftImgUrl, nftName: entity.nftName, description: entity.description, memberName: entity.memberName, memberImageUrl: entity.profileImgUrl)
        
        let detailInfoData = DetailInfoData(price: entity.price, tokenId: entity.tokenId, contractAddress: entity.contractAddress)
            
        let communityData = CommunityData(followed: entity.followed, liked: entity.liked, isMe: entity.isMe)
            
        return [
            .overview(overviewData),
            .detailInfo(detailInfoData),
            .community(communityData)
        ]
    }
    
    private func getNFTDetailData() -> Observable<NFTDetailEntity> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            self.marketRepository.getNFTDetail(nftId: 1) { result in
                switch result {
                case .success(let response):
                    let entity = response.toEntity()
                    observer.onNext(entity)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}


struct OverviewData {
    let nftImageUrl : String
    let nftName: String
    let description: String
    let memberName: String
    let memberImageUrl : String
}

struct DetailInfoData {
    let price: String
    let tokenId: String
    let contractAddress: String
}

struct CommunityData {
    let followed: Bool
    let liked: Bool
    let isMe: Bool
}