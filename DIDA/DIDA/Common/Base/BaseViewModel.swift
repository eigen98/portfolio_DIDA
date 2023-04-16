//
//  BaseViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import Foundation
import RxSwift
import RxRelay

protocol BaseViewModelInterface {
    var showLoading: PublishRelay<Bool> { get }
    var showError: PublishSubject<Error> { get }
    var showSnackBar: PublishSubject<SnackBar> { get }
    // toast 구현 후 변경 필요
    var showToastMessage: PublishSubject<Bool> { get }

}

class BaseViewModel: BaseViewModelInterface {
    
    
    init() {
        self.bind()
    }
    
    var showLoading = PublishRelay<Bool>()
    var showError = PublishSubject<Error>()
    var showSnackBar = PublishSubject<SnackBar>()
    var showToastMessage = PublishSubject<Bool>()
    
    func bind() {
        // input이랑 output 연결
    }
}
