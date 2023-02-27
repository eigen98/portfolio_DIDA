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
    let test: String?
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
    case noisyItem(test: String)
    case postItem(userName: String, title: String, content: String, cardName: String, price: String, commentList: [TestComment])
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
    
    var noisyData = BehaviorRelay<[SectionItem]>(value: [])
    var postsData = BehaviorRelay<[SectionItem]>(value: [])
   
    func fetchData() {
        noisyData.accept([SectionItem.noisyItem(test: "")])
        postsData.accept([SectionItem.postItem(userName: "두리", title: "hi", content: "hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello", cardName: "duri", price: "11", commentList: [TestComment(userProfile: "ㅎㅎ", content: "굳굳"),TestComment(userProfile: "gsad", content: "ㅇㅇㅇㅇㅇㅇㅇ"),TestComment(userProfile: "heehee", content: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ")]),
                          SectionItem.postItem(userName: "정민", title: "bye", content: "dsfdfdsfdsfdsfsdafadsfasdfasfsda", cardName: "오우", price: "123233444444", commentList: [TestComment(userProfile: "dsfa", content: "나나나난")]),
                          SectionItem.postItem(userName: "희철", title: "ddd", content: "ddd", cardName: "ccc", price: "09132912", commentList: [])])
    }
    
}
