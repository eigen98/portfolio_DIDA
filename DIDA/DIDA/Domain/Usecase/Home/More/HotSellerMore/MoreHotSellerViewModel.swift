//
//  MoreHotSellerViewModel.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/26.
//

import Foundation
import RxSwift
class MoreHotSellerViewModel : BaseViewModel{
    var disposeBag = DisposeBag()
    var input : Input
    var output : Output
    
    struct Input {
        
    }
    
    struct Output{
        var hotSellerData : BehaviorSubject<[UserEntity]>
    }
    
    override init() {
        
        self.input = Input()
        self.output = Output(hotSellerData: BehaviorSubject(value: []))
    }
    
    override func bind() {
        super.bind()
        //Mock Data
//        output.hotSellerData.onNext([HotSellerEntity(userId: 7, sellerBacground: "NFT의 imgUrl", sellerProfile: "유저의 imgUrl", sellerName: "yoo_jitsu"),
//                                     HotSellerEntity(userId: 7, sellerBacground: "NFT의 imgUrl", sellerProfile: "유저의 imgUrl", sellerName: "yoo_jitsu")])
    }
}
