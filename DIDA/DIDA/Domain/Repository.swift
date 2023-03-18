//
//  Repository.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/03/03.
//

import UIKit

protocol TestCommunityRepositoryType {
    func fetchTestNoisyData() -> [SectionItem]
    func fetchTestPostData() -> [SectionItem]
}

final class Repository: TestCommunityRepositoryType {
    
    private init() {}
    
    static let shared = Repository()
    
    func fetchTestNoisyData() -> [SectionItem] {
        return [SectionItem.noisyItem(TestNoisyData(test: [Colors.text_notice_red!,Colors.brand_ivory!,Colors.brand_ivory!,Colors.brand_lemon_1000!,Colors.brand_ivory!,Colors.brand_lemon_1000!,Colors.text_notice_red!,Colors.brand_ivory!,Colors.brand_lemon_1000!]))]
    }
    func fetchTestPostData() -> [SectionItem] {
        [SectionItem.postItem(TestPosts(userName: "두리", title: "hi", content: "hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello", cardName: "duri", price: "11", commentList: [TestComment(userProfile: "ㅎㅎ", content: "굳굳"),TestComment(userProfile: "gsad", content: "ㅇㅇㅇㅇㅇㅇㅇ"),TestComment(userProfile: "heehee", content: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ")])),SectionItem.postItem(TestPosts(userName: "정민", title: "bye", content: "dsfdfdsfdsfdsfsdafadsfasdfasfsda", cardName: "오우", price: "123233444444", commentList: [TestComment(userProfile: "dsfa", content: "나나나난")])),SectionItem.postItem(TestPosts(userName: "희철", title: "ddd", content: "ddd", cardName: "ccc", price: "09132912", commentList: [])),SectionItem.postItem(TestPosts(userName: "두리", title: "hi", content: "hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello", cardName: "duri", price: "11", commentList: [TestComment(userProfile: "ㅎㅎ", content: "굳굳"),TestComment(userProfile: "gsad", content: "ㅇㅇㅇㅇㅇㅇㅇ"),TestComment(userProfile: "heehee", content: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ")])),SectionItem.postItem(TestPosts(userName: "정민", title: "bye", content: "dsfdfdsfdsfdsfsdafadsfasdfasfsda", cardName: "오우", price: "123233444444", commentList: [TestComment(userProfile: "dsfa", content: "나나나난")]))]
    }
}
