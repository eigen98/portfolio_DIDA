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
    private var socialInteractionRepository: SocialInteractionRepository
    
    enum SectionItem {
        case overview(OverviewNFTModel?)
        case detailInfo(DetailInfoNFTModel?)
        case community(DetailCommunityModel?)
        
        var overviewData: OverviewNFTModel? {
            if case let .overview(data) = self {
                return data
            }
            return nil
        }
        
        var detailInfoData: DetailInfoNFTModel? {
            if case let .detailInfo(data) = self {
                return data
            }
            return nil
        }
    }

    
    struct Input {
        let refreshTrigger: PublishRelay<Int>
        let followButtonTapped: PublishRelay<Void>
        let likeButtonTapped: PublishRelay<Int>
        let transactionButtonTapped: PublishRelay<Void>
    }

    
    struct Output {
        var nftDetailData: BehaviorSubject<[SectionItem]>
        var priceObservable: BehaviorSubject<String?>
        let followStatusChanged: BehaviorSubject<Bool>
        let likeStatusChanged: BehaviorSubject<Bool>
        let transactionResult: PublishSubject<Result<Void, Error>>
    }
    
    init(marketRepository: MarketRepository = MarketRepositoryImpl(),
         socialInteractionRepository : SocialInteractionRepository = SocialInteractionRepositoryImpl()
    ) {
        self.marketRepository = marketRepository
        self.socialInteractionRepository = socialInteractionRepository
        input = Input(refreshTrigger: PublishRelay<Int>(),
                      followButtonTapped: PublishRelay<Void>(),
                      likeButtonTapped:  PublishRelay<Int>(),
                      transactionButtonTapped: PublishRelay<Void>())

        output = Output(nftDetailData: BehaviorSubject<[SectionItem]>(value: [
            .community(nil),
            .detailInfo(nil),
            .overview(nil)]),
                        priceObservable: BehaviorSubject<String?>(value: nil),
                        followStatusChanged: BehaviorSubject<Bool>(value: false),
                        likeStatusChanged:  BehaviorSubject<Bool>(value: false),
                        transactionResult: PublishSubject<Result<Void, Error>>())
        disposeBag = DisposeBag()
        super.init()
        
    }
    
    override func bind() {
        super.bind()
        
        bindRefreshTrigger()
        bindNFTDetailData()
        bindFollowButtonTapped()
        bindLikeButtonTapped()
        bindTransactionButtonTapped()

    }
    
    private func bindRefreshTrigger() {
        input.refreshTrigger
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(true)
            })
            .flatMapLatest { [weak self] id -> Observable<NFTDetailEntity> in
                guard let self = self else { return Observable.empty() }
                return self.getNFTDetailData(nftId: id)
            }
            .do(onNext: { [weak self] _ in
                self?.showLoading.accept(false)
            })
            .map { [weak self] entity -> [SectionItem] in
                return self?.convertEntityToViewModel(entity: entity) ?? []
            }
            .bind(to: output.nftDetailData)
            .disposed(by: disposeBag)
    }
    
    private func bindNFTDetailData() {
        output.nftDetailData
            .map { sectionItems in
                sectionItems.compactMap { $0.detailInfoData?.price }.first
            }
            .bind(to: output.priceObservable)
            .disposed(by: disposeBag)
        
        output.nftDetailData
            .map{ sectionItems in
                sectionItems.compactMap { $0.overviewData?.liked }.first ?? false
            }
            .bind(to: output.likeStatusChanged)
            .disposed(by: disposeBag)
    }
    
    private func bindFollowButtonTapped() {
        input.followButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.followButtonAction()
            })
            .disposed(by: disposeBag)
    }

    private func bindLikeButtonTapped() {
        input.likeButtonTapped
            .subscribe(onNext: { [weak self] id in
                guard let self = self else { return }
                self.likeNFTAction(nftId: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTransactionButtonTapped() {
        input.transactionButtonTapped
            .withLatestFrom(output.nftDetailData)
            .flatMap { [weak self] sectionItems -> Observable<Result<Void, Error>> in
                guard let self = self else { return .empty() }
                guard let overviewData = sectionItems.compactMap({ $0.overviewData }).first else {
                    return .just(.failure(PurchaseNFTErrors.didaCheckFailed))
                }
                
                if overviewData.isMe {
                    return self.performSellLogic()
                } else {
                    return self.performPurchaseLogic()
                }
            }
            .bind(to: output.transactionResult)
            .disposed(by: disposeBag)
    }

    private func followButtonAction() {
        guard let sectionItems = try? output.nftDetailData.value(),
              let memberId = extractMemberId(from: sectionItems)
        else {
            return
        }
        
        socialInteractionRepository.followUser(memberId: memberId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isFollowing):
                self.output.followStatusChanged.onNext(isFollowing)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func likeNFTAction(nftId : Int) {
        socialInteractionRepository.likeNFT(nftId: nftId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isLiked):
                self.output.likeStatusChanged.onNext(isLiked)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func extractMemberId(from sectionItems: [SectionItem]) -> Int? {
        return sectionItems.compactMap { $0.overviewData?.memeberId }.first
    }

    
    private func convertEntityToViewModel(entity: NFTDetailEntity) -> [SectionItem] {
        let overviewData = OverviewNFTModel(nftImageUrl: entity.nftImgUrl,
                                            nftName: entity.nftName,
                                            liked: entity.liked,
                                            description: entity.description,
                                            memeberId: entity.memberId,
                                            memberName: entity.memberName,
                                            memberImageUrl: entity.profileImgUrl,
                                            followed: entity.followed,
                                            isMe: entity.isMe)
        
        let detailInfoData = DetailInfoNFTModel(price: entity.price,
                                            tokenId: entity.tokenId,
                                            contractAddress: entity.contractAddress)
            
        let communityData = DetailCommunityModel(liked: entity.liked,
                                          isMe: entity.isMe)
            
        return [
            .overview(overviewData),
            .detailInfo(detailInfoData),
            .community(communityData)
        ]
    }
    
    private func getNFTDetailData(nftId : Int) -> Observable<NFTDetailEntity> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            self.marketRepository.getNFTDetail(nftId: nftId) { result in
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
    
    private func performSellLogic() -> Observable<Result<Void, Error>> {
        return Disposables.create() as! Observable<Result<Void, any Error>>
    }

    private func performPurchaseLogic() -> Observable<Result<Void, Error>> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let payPwd = ""
            let marketId = 2
            
            self.marketRepository.purchaseNFT(payPwd: payPwd, marketId: marketId) { result in
                switch result {
                case .success(let response):
                    //MARK: 구매 성공 시
                    observer.onNext(.success(()))
                case .failure(let error):
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }

}
