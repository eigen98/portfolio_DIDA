//
//  BaseViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import Foundation
import RxSwift
import RxRelay

protocol BaseViewModelInput { }
protocol BaseViewModelOutput { }

protocol BaseViewModelInterface {
    var showLoading: PublishRelay<Bool> { get }
    var showErrorMessage: PublishSubject<String> { get }
    var showToastMessage: PublishSubject<Bool> { get }

}

class BaseViewModel: BaseViewModelInterface {
    
    
    init() {
        self.bind()
    }
    
    var showLoading = PublishRelay<Bool>()
    var showErrorMessage = PublishSubject<String>()
    var showToastMessage = PublishSubject<Bool>()
    
    func bind() {
        // input이랑 output 연결
    }
}

extension BaseViewModel: BaseViewModelInput {
    
}

extension BaseViewModel: BaseViewModelOutput {
    
}
