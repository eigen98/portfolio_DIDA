//
//  SwapViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/21.
//

import RxSwift

class SwapViewModel: BaseViewModel {
    
    struct Input {
        let fetchWalletInfoTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let walletKlayBalance: Observable<String>
        let sendingCoin: Observable<CoinEntity>
        let receivingCoin: Observable<CoinEntity>
        let error: Observable<Error>
    }
    
    let input: Input = Input()
    let output: Output
    
    private let disposeBag = DisposeBag()
    private let userRepository: UserRepository
    private let walletEntitySubject: BehaviorSubject<WalletEntity?> = BehaviorSubject(value: nil)
    private let sendingCoinSubject = BehaviorSubject<CoinEntity>(value: CoinEntity(type: .klay, amount: 0))
    private let receivingCoinSubject = BehaviorSubject<CoinEntity>(value: CoinEntity(type: .dida, amount: 0))

    private let errorSubject: PublishSubject<Error> = PublishSubject()
    
    init(userRepository: UserRepository = UserRepositoryImpl()) {
        self.userRepository = userRepository
        
        let walletKlayBalance = walletEntitySubject
            .compactMap { $0?.klay }
            .map { "\($0)" }
        
        self.output = Output(
            walletKlayBalance: walletKlayBalance,
            sendingCoin: sendingCoinSubject.asObservable(),
            receivingCoin: receivingCoinSubject.asObservable(),
            error: errorSubject.asObservable()
        )
        
        super.init()
        
        bind()
    }
    
    override func bind() {
        super.bind()
        
        input.fetchWalletInfoTrigger.subscribe(onNext: { [weak self] in
            self?.fetchWalletInfo()
        }).disposed(by: disposeBag)
    }
    
    private func fetchWalletInfo() {
        userRepository.checkWalletExistence { [weak self] (exists, error) in
            if let error = error {
                self?.handleError(error)
                return
            }
            if exists == true {
                self?.fetchExistingWallet()
            } else {
                self?.walletEntitySubject.onNext(nil)
            }
        }
    }
    
    private func fetchExistingWallet() {
        userRepository.fetchWallet(completion: { [weak self] (walletEntity, error) in
            if let error = error {
                self?.handleError(error)
                return
            }
            
            if let wallet = walletEntity {
                self?.sendingCoinSubject.onNext(CoinEntity(type: .klay, amount: wallet.klay ))
                self?.receivingCoinSubject.onNext(CoinEntity(type: .dida, amount: wallet.dida ))
            }
        })
    }
    
    func swapCoins() {
        Observable.combineLatest(sendingCoinSubject, receivingCoinSubject)
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] sending, receiving in
                self?.sendingCoinSubject.onNext(receiving)
                self?.receivingCoinSubject.onNext(sending)
            }).disposed(by: disposeBag)
    }
    
    private func handleError(_ error: Error) {
        self.errorSubject.onNext(error)
    }
}
