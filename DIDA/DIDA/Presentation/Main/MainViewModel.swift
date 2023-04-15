//
//  MainViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import Foundation

protocol MainViewModelOutput {
    var isLogin: Bool { get }
}

class MainViewModel: BaseViewModel {
    
    private let userRepository: UserRepository
    
    override init() {
        self.userRepository = UserRepositoryImpl()
    }
    
    override func bind() {
        
    }
}

extension MainViewModel: MainViewModelOutput {
    var isLogin: Bool {
        return self.userRepository.isLogin()
    }
}
