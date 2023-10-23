//
//  VerificationCodeInputViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard

class VerificationCodeInputViewController: BaseViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var codeTextField: TextField!
    
    @IBOutlet weak var retrySendButton: UIButton!
    
    @IBOutlet weak var timeoutNoticeLabel: UILabel!
    
    @IBOutlet weak var emailSentStatusLabel: UILabel!
    
    @IBOutlet weak var confirmButton: Buttons!
    
    
    @IBOutlet weak var buttomBottomConstraint: NSLayoutConstraint!
    
    let viewModel = VerificationCodeInputViewModel()
       let disposeBag = DisposeBag()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setUI()
           bindEvents()
           bindViewModel()
           viewModel.sendVerificationEmail()
           
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
              tapGesture.cancelsTouchesInView = false
              self.view.addGestureRecognizer(tapGesture)
           
       }
       
       func bindEvents() {
           self.retrySendButton.rx.tap
               .bind(to: viewModel.input.retryButtonTapped)
               .disposed(by: disposeBag)
           
           self.codeTextField.rx.text
               .bind(to: viewModel.input.codeEntered)
               .disposed(by: disposeBag)
           
           self.codeTextField.rx
               .controlEvent(.editingDidBegin)
               .subscribe(onNext: { [weak self] in
                   self?.codeTextField.layer.borderColor = UIColor.yellow.cgColor
               }).disposed(by: disposeBag)
           
           self.codeTextField.rx
               .controlEvent(.editingDidEnd)
               .subscribe(onNext: { [weak self] in
                   self?.codeTextField.layer.borderColor = UIColor.gray.cgColor
           }).disposed(by: disposeBag)
           
           self.codeTextField.rx.text.subscribe(onNext: { text in
               let text = text ?? ""
               self.confirmButton.isEnabled = text.count > 1
           }).disposed(by: self.disposeBag)
           
           self.confirmButton.rx.tap
               .subscribe(onNext: { [weak self] in
                   self?.viewModel.input.confirmButtonTapped.accept(())
               }).disposed(by: disposeBag)
           
       }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.output
            .timerText
            .bind(to: self.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output.timerText
            .observe(on: MainScheduler.instance)
            .bind(to: self.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output
            .timerExpired
            .subscribe(onNext: { [weak self] expired in
                if expired {
                    self?.timerLabel.textColor = UIColor.red
                    self?.codeTextField.layer.borderColor = UIColor.red.cgColor
                    self?.timeoutNoticeLabel.isHidden = false
                    self?.confirmButton.isEnabled = false
                } else {
                    self?.timerLabel.textColor = UIColor.white
                    self?.codeTextField.layer.borderColor = UIColor.gray.cgColor
                    self?.timeoutNoticeLabel.isHidden = true
                    self?.confirmButton.isEnabled = true
                }
            }).disposed(by: disposeBag)
        
        self.viewModel.output
            .verificationSuccess
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let presentingVC = self?.presentingViewController else { return }
                self?.dismiss(animated: true, completion: { [weak presentingVC] in
                    let passwordConfigurationVC = PasswordConfigurationViewController(with: .changePassword)
                    passwordConfigurationVC.modalPresentationStyle = .fullScreen
                    presentingVC?.present(passwordConfigurationVC, animated: true, completion: nil)
                })
            }).disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight.distinctUntilChanged().drive(onNext: { [weak self] height in
            guard let `self` = self else { return }
            
            if height > 0 {
                self.buttomBottomConstraint.constant = height
            } else {
                self.buttomBottomConstraint.constant = 0
            }
        }).disposed(by: self.disposeBag)
    }
    
    func setUI(){
        codeTextField.placeholder = "6자리 숫자"
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.buttonHeight = .h56
        confirmButton.style = .primary
        confirmButton.shape = .round
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
}
