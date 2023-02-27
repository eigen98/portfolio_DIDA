//
//  PostViewModel.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/27.
//

import UIKit
import RxSwift
import RxCocoa

final class PostViewModel: BaseViewModel {
    
    var comments = BehaviorRelay<[TestComment]>(value: [])
    
    func fetchComment(_ data: [TestComment]) {
        comments.accept(data)
    }
    
    func getCommentCount() -> Int {
        return comments.value.count
    }
}
