//
//  PurchaseNFTViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/17.
//

import RxSwift
import RxCocoa

class PurchaseNFTViewModel: BaseViewModel {
    
    
    private let userRepository: UserRepository
    private let marketRepository: MarketRepository
    
    private let currentNFTID: Int
    
    struct Input {
        let purchaseTrigger = PublishSubject<Void>()
        let cancelTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let nftImageSubject = BehaviorSubject<String>(value: "")
        let nftNameSubject = BehaviorSubject<String>(value: "")
        let usernameSubject = BehaviorSubject<String>(value: "")
        let didaBalanceSubject = BehaviorSubject<String>(value: "")
        let paymentInfoPriceSubject = BehaviorSubject<String>(value: "")
        let feePriceSubject = BehaviorSubject<String>(value: "")
        let totalPriceSubject = BehaviorSubject<String>(value: "")
        let remainingBalanceAfterPaymentSubject = BehaviorSubject<String>(value: "")
        
        let buyerSubject = BehaviorSubject<String>(value: "")
        let sellerSubject = BehaviorSubject<String>(value: "")
        
        let showPurchaseSuccess: Observable<Void>
        let showPurchaseCancel: Observable<Void>
    }
    
    let input: Input = Input()
    let output: Output
    
    private let disposeBag = DisposeBag()

    private let showPurchaseSuccess = PublishSubject<Void>()
    private let showPurchaseCancel = PublishSubject<Void>()
    
    init(userRepository : UserRepository = UserRepositoryImpl(),
         marketRepository : MarketRepository = MarketRepositoryImpl(),
         currentNFTID: Int
    ) {
        self.userRepository = userRepository
        self.marketRepository = marketRepository
        self.currentNFTID = currentNFTID
        self.output = Output(
            showPurchaseSuccess: showPurchaseSuccess.asObservable(),
            showPurchaseCancel: showPurchaseCancel.asObservable()
        )
        super.init()
    }
    
    override func bind() {
        super.bind()
        bindInputs()
        bindUserDetails()
        bindNFTDetails()
    }
    
    private func bindInputs() {
        input.purchaseTrigger.subscribe(onNext: { [weak self] in
            self?.showPurchaseSuccess.onNext(())
        }).disposed(by: disposeBag)
        
        input.cancelTrigger.subscribe(onNext: { [weak self] in
            self?.showPurchaseCancel.onNext(())
        }).disposed(by: disposeBag)
    }
    
    private func bindUserDetails() {
        userRepository.fetchMyselfObservable().subscribe(onNext: {[weak self] userEntity in
            if let user = userEntity {
                self?.output.buyerSubject.onNext(user.nickname ?? "")
            }
        }).disposed(by: disposeBag)
        
        userRepository.fetchWallet { [weak self] (walletEntity, error) in
            if let wallet = walletEntity {
                let didaBalance =  "\(wallet.dida) dida"
                self?.output.didaBalanceSubject.onNext(didaBalance)
            } else if let error = error {
                
                print(error.localizedDescription)
            }
        }
    }

    private func bindNFTDetails() {
        marketRepository.getNFTDetail(nftId: currentNFTID) { [weak self] result in
            switch result {
            case .success(let response):
                let nftDetail = response.toEntity()
                self?.output.nftImageSubject.onNext(nftDetail.nftImgUrl)
                self?.output.usernameSubject.onNext(nftDetail.memberName)
                self?.output.nftNameSubject.onNext(nftDetail.nftName)
                self?.output.sellerSubject.onNext(nftDetail.memberName)
                
                let price = self?.roundedPrice(value: nftDetail.price) ?? "0.0"
                self?.output.paymentInfoPriceSubject.onNext("\(price) dida")
                
                if let totalPrice = Double(nftDetail.price) {
                    self?.output.totalPriceSubject.onNext("\(totalPrice) dida")
                    self?.updateRemainingBalance(totalPrice: totalPrice)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateRemainingBalance(totalPrice: Double) {
        userRepository.fetchWallet { [weak self] (walletEntity, error) in
            guard let self = self, let wallet = walletEntity else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let currentBalance = Double(wallet.dida)
            let remainingBalance = currentBalance - totalPrice
            self.output.remainingBalanceAfterPaymentSubject.onNext("\(remainingBalance) dida")
        }
    }
    
    private func roundedPrice(value: String) -> String {
        if value.isEmpty { return "0.00" }
        
        if let doubleValue = Double(value) {
            let absValue = abs(doubleValue)
            let sign = doubleValue < 0 ? "-" : ""
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            let (divisor, suffix): (Double, String) = {
                if absValue < 1_000 { return (1, "") }
                if absValue < 1_000_000 { return (1_000, "K") }
                return (1_000_000, "M")
            }()
            
            let formattedValue = formatter.string(from: NSNumber(value: absValue / divisor)) ?? ""
            return "\(sign)\(formattedValue)\(suffix)"
        } else {
            return value
        }
    }
    
}
