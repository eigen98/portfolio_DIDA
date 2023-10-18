//
//  PurchaseNFTViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/17.
//

import RxSwift
import RxCocoa

class PurchaseNFTViewModel: BaseViewModel {
    
    struct Input {
        let purchaseTrigger = PublishSubject<Void>()
        let cancelTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nftImage: Observable<UIImage>
        let nftName: Observable<String>
        let username: Observable<String>
        let didaBalance: Observable<String>
        let paymentInfoPrice: Observable<String>
        let feePrice: Observable<String>
        let totalPrice: Observable<String>
        let remainingBalanceAfterPayment: Observable<String>
        let showPurchaseSuccess: Observable<Void>
        let showPurchaseCancel: Observable<Void>
    }
    
    let input: Input = Input()
    let output: Output
    
    private let disposeBag = DisposeBag()

    private let mockNFTImage = Observable.just(UIImage(named: "nftImage") ?? .remove)
    private let mockNFTName = Observable.just("NFT Name")
    private let mockUsername = Observable.just("Username")
    
    private let mockDidaBalance = Observable.just("5000 dida")
    private let mockPaymentInfoPrice = Observable.just("324.91 dida")
    private let mockFeePrice = Observable.just("123 dida")
    private let mockTotalPrice = Observable.just("447.91 dida")
    private let mockRemainingBalanceAfterPayment = Observable.just("4552.09 dida")
    
    private let showPurchaseSuccess = PublishSubject<Void>()
    private let showPurchaseCancel = PublishSubject<Void>()
    
    override init() {
        self.output = Output(
            nftImage: mockNFTImage,
            nftName: mockNFTName,
            username: mockUsername,
            didaBalance: mockDidaBalance,
            paymentInfoPrice: mockPaymentInfoPrice,
            feePrice: mockFeePrice,
            totalPrice: mockTotalPrice,
            remainingBalanceAfterPayment: mockRemainingBalanceAfterPayment,
            showPurchaseSuccess: showPurchaseSuccess.asObservable(),
            showPurchaseCancel: showPurchaseCancel.asObservable()
        )
        super.init()
    }
    
    override func bind() {
        super.bind()
        
        input.purchaseTrigger.subscribe(onNext: { [weak self] in
            
            self?.showPurchaseSuccess.onNext(())
        }).disposed(by: disposeBag)
        
        input.cancelTrigger.subscribe(onNext: { [weak self] in
           
            self?.showPurchaseCancel.onNext(())
        }).disposed(by: disposeBag)
    }
}
