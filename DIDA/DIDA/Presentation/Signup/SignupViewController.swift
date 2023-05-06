//
//  SignupViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import UIKit
import RxSwift
import RxKeyboard

class SignupViewController: BaseViewController {
    
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var signupbutton: Buttons!
    @IBOutlet weak var buttomBottomConstraint: NSLayoutConstraint!
    
    let viewModel = SignupViewModel()
    
    var email: String? {
        didSet {
            self.viewModel.input.email.accept(self.email)
        }
    }
    
    let limitCount = 10
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        textField.maxLength = self.limitCount
        textField.placeholder = "닉네임을 입력해주세요"
        
        textCountLabel.text =  String(format: "%d/%d", 0, self.limitCount)
        
        signupbutton.setTitle("가입 완료", for: .normal)
        signupbutton.buttonHeight = .h56
        signupbutton.style = .primary
        signupbutton.shape = .round
        
        bindEvent()
        bindViewModel()
    }
    
    override func bindEvent() {
        
        self.view.rx.tapGesture.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.view.endEditing(true)
        }.disposed(by: self.disposeBag)
        
        self.textField.rx.text.bind { [weak self] text in
            guard let `self` = self else { return }
            
            self.textCountLabel.text = String(format: "%d/%d", text?.count ?? 0, self.limitCount)
            self.viewModel.input.nicknameInput.onNext(text)
        }.disposed(by: self.disposeBag)
        
        self.signupbutton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.asyncInstance).bind { [weak self] _ in
            guard let `self` = self else { return }
            
            self.viewModel.signup()
        }.disposed(by: self.disposeBag)
        
        RxKeyboard.instance.visibleHeight.distinctUntilChanged().drive(onNext: { [weak self] height in
            guard let `self` = self else { return }
            
            if height > 0 {
                self.buttomBottomConstraint.constant = height
            } else {
                self.buttomBottomConstraint.constant = 0
            }
        }).disposed(by: self.disposeBag)
    }
    
    override func bindViewModel() {
        self.viewModel.showError.bind { [weak self] error in
            guard let `self` = self else { return }
            self.showError(error: error)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.output.isSavable.bind(to: self.signupbutton.rx.isEnabled).disposed(by: self.disposeBag)
    }
    
}
