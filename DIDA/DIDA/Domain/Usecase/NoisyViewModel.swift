//
//  NoisyViewModel.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/27.
//

import UIKit
import RxCocoa
import RxSwift

//임시 모델
struct TestNoisy {
    let nft: String?
}

final class NoisyViewModel: BaseViewModel {
    
    var noisyNFT = BehaviorRelay<[TestNoisy]>(value: [])
    
    func fetchNoisyNFT() {
        noisyNFT.accept([TestNoisy(nft: ""),TestNoisy(nft: ""),TestNoisy(nft: ""),TestNoisy(nft: ""),TestNoisy(nft: "")])
    }
}
