//
//  OwnershipNFTViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/30.
//

import Foundation
import RxSwift
import RxDataSources

class OwnershipNFTViewModel {
    
    struct Input {
        let refreshTrigger: Observable<Void>
    }
    
    struct Output {
        let sections: Observable<[SectionModel<String, Owner>]>
    }
    
    func transform(input: Input) -> Output {
        let sections = input.refreshTrigger
            .flatMapLatest { [weak self] in
                self?.fetchOwnershipData() ?? .just([])
            }
        
        return Output(sections: sections)
    }
    
    private func fetchOwnershipData() -> Observable<[SectionModel<String, Owner>]> {
      
        let currentOwner = Owner(date: "2023-09-30", userName: "Current User", price: "$1000")
        let previousOwner1 = Owner(date: "2023-09-29", userName: "User1", price: "$900")
        let previousOwner2 = Owner(date: "2023-09-28", userName: "User2", price: "$800")
        
        let sections = [
            SectionModel(model: "현재 소유자", items: [currentOwner]),
            SectionModel(model: "이전 소유 내역", items: [previousOwner1, previousOwner2])
        ]
        
        return .just(sections)
    }
}
