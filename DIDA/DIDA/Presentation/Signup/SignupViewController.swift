//
//  SignupViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/05/06.
//

import UIKit
import RxSwift
import RxKeyboard

protocol SignupViewControllerDelegate: AnyObject {
    func didSusccessLoginSignup()
}

class SignupViewController: BaseViewController {
    
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var textField: TextField!
    @IBOutlet weak var signupbutton: Buttons!
    @IBOutlet weak var buttomBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: SignupViewControllerDelegate?
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    override func bindEvent() {
        
        self.textField.rx.text.bind { [weak self] text in
            guard let `self` = self else { return }
            let inputStringCnt = text?.count ?? 0
            
            self.textCountLabel.text = String(format: "%d/%d", inputStringCnt, self.limitCount)
            self.signupbutton.isEnabled = inputStringCnt > 1
        }.disposed(by: self.disposeBag)
        
        self.textField.rx.text.debounce(.seconds(1), scheduler: MainScheduler.asyncInstance).bind { [weak self] text in
            guard let `self` = self else { return }
            
            self.viewModel.input.nicknameInput.accept(text)
            self.viewModel.checkDuplictated()
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
        
        self.viewModel.output.isSuccess.filter { $0 }.take(1).bind { [weak self] _ in
            guard let `self` = self else { return }
            
            self.delegate?.didSusccessLoginSignup()
        }.disposed(by: self.disposeBag)
    }
    
}
