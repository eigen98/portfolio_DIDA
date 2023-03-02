//
//  CommunityViewModel.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/27.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

//MARK: - 임시 모델
struct TestNoisyData {
    let test: [UIColor]?
}
struct TestPosts {
    let userName: String?
    let title: String?
    let content: String?
    let cardName: String?
    let price: String?
    let commentList: [TestComment]?
}
struct TestComment {
    let userProfile: String?
    let content: String?
}

//RxDataSource
enum SectionItem {
    case noisyItem(TestNoisyData)
    case postItem(TestPosts)
}
enum CommunitySectionModel: SectionModelType {
    typealias Item = SectionItem
    
    case noisySection(items: [SectionItem])
    case postSection(items: [SectionItem])
    
    var items: [Item] {
        switch self {
        case .noisySection(let items):
            return items.map { $0 }
        case .postSection(let items):
            return items.map { $0 }
        }
    }
    
    init(original: CommunitySectionModel, items: [Item]) {
        switch original {
        case .noisySection(let items):
            self = .noisySection(items: items)
        case .postSection(let items):
            self = .postSection(items: items)
        }
    }
}

final class CommunityViewModel: BaseViewModel {
    
    struct Input {
        let noisyData: BehaviorRelay<[SectionItem]>
        let postsData: BehaviorRelay<[SectionItem]>
    }
    struct Output {
        let communityData: Driver<[CommunitySectionModel]>
    }
    
    var noisyData = BehaviorRelay<[SectionItem]>(value: [])
    var postsData = BehaviorRelay<[SectionItem]>(value: [])
    
    var input: Input?
    var output: Output?
    
    override func bind() {
        super.bind()
        
        let noisyData = noisyData
        let postsData = postsData
        let communityData = Observable.combineLatest(noisyData, postsData)
                            .map { (noisyData, postData) -> [CommunitySectionModel] in
                                let noisySection = CommunitySectionModel.noisySection(items: noisyData)
                                let postSection = CommunitySectionModel.postSection(items: postData)
                                return [noisySection, postSection]
                            }
                            .asDriver(onErrorJustReturn: [])
        input = Input(noisyData: noisyData, postsData: postsData)
        output = Output(communityData: communityData)
    }
    
    func fetchData() {
        noisyData.accept(Repository.shared.fetchTestNoisyData())
        postsData.accept(Repository.shared.fetchTestPostData())
    }
    
}
