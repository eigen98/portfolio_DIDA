//
//  SignupViewModel.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import Foundation
import RxSwift
import RxRelay

class SignupViewModel: BaseViewModel {
    
    struct Input {
        let nicknameInput = PublishSubject<String?>()
        let email = BehaviorRelay<String?>(value: nil)
    }
    
    struct Output {
        let isSavable: Observable<Bool>
    }
    
    private let userRepository: UserRepository
    
    private let isSavable = BehaviorRelay<Bool>(value: false)
    
    let input: Input
    let output: Output
    let disposeBag = DisposeBag()
    
    override init() {
        self.userRepository = UserRepositoryImpl()
        self.input = Input()
        
        self.output = Output(
            isSavable: self.isSavable.asObservable()
        )
    }
    
    func signup() {
        self.userRepository.signup()
    }
}
