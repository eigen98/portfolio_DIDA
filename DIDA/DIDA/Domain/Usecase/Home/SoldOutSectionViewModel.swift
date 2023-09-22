//
//  SoldOutSectionViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/05/02.
//

import Foundation
import RxSwift

class SoldOutSectionViewModel : BaseViewModel{
    
    private var disposeBag : DisposeBag
    private let homeRepository: HomeRepository
    
    var input: Input
    var output: Output
    
    struct Input {
        let refreshTrigger: PublishSubject<Int>
    }
    
    struct Output {
        var soldoutOutput: BehaviorSubject<[NFTEntity]>
        var isLoading: BehaviorSubject<Bool>
        var isRefreshing: BehaviorSubject<Bool>
    }
    
    override init() {
        input = Input(refreshTrigger: PublishSubject<Int>())
        output = Output(soldoutOutput: BehaviorSubject<[NFTEntity]>(value: []),
                        isLoading: BehaviorSubject<Bool>(value: false),
                        isRefreshing: BehaviorSubject<Bool>(value: false))
        self.homeRepository = HomeRepositoryImpl()
        disposeBag = DisposeBag()
    }
    
    override func bind() {
        input.refreshTrigger
            .subscribe(onNext: { [weak self] term in
                self?.homeRepository.getMainSoldout(range: term) { [weak self] result in
                    switch result {
                    case .success(let response):
                        let entities = response.nftAndMemberInfos?.toDomain() ?? []
                        self?.output.soldoutOutput.onNext(entities)
                    case .failure(let error):
                        print("Error getting data: \(error)")
                    }
                }
            })
            .disposed(by: disposeBag)
        
        input.refreshTrigger
            .map { _ in true }
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
        
        output.soldoutOutput
            .map { _ in false }
            .bind(to: output.isRefreshing)
            .disposed(by: disposeBag)
    }
}
