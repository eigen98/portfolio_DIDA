//
//  LoginHomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import UIKit
import RxSwift

protocol LoginHomeViewControllerDelegate: AnyObject {
    func didSusccessLogin()
}

class LoginHomeViewController: BaseViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnApple: Buttons!
    @IBOutlet weak var btnKakao: Buttons!
    
    let viewModel = LoginHomeViewModel()
    let disposeBag = DisposeBag()
    
    let kakaoColor = UIColor.init(hex: "#fee500")
    let appleColor = UIColor.init(hex: "#ffffff")
    
    weak var delegate: LoginHomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        configure()
        bindEvent()
        bindViewModel()
    }
    
    private func configure() {
        self.btnKakao.setTitle("카카오톡으로 시작하기", for: .normal)
        self.btnKakao.style = .custom(.init(normal: kakaoColor, disabled: kakaoColor, selected: kakaoColor, hightlight: kakaoColor))
        self.btnKakao.shape = .round
        self.btnKakao.buttonHeight = .h56
        
        self.btnApple.setTitle("Apple로 시작하기", for: .normal)
        self.btnApple.style = .custom(.init(normal: appleColor, disabled: appleColor, selected: appleColor, hightlight: appleColor))
        self.btnApple.shape = .round
        self.btnApple.buttonHeight = .h56
    }
    
    override func bindEvent() {
        self.btnClose.rx.tap.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.dismiss(animated: true)
        }.disposed(by: self.disposeBag)
        
        self.btnApple.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance).bind(to: self.viewModel.input.tapAppleLoginButton).disposed(by: self.disposeBag)
        self.btnKakao.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance).bind(to: self.viewModel.input.tapKakaoLoginButton).disposed(by: self.disposeBag)
    }
    
    
    override func bindViewModel() {
        self.viewModel.showError.bind { [weak self] error in
            guard let `self` = self else { return }
            self.showError(error: error)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.ouptut.goToSignup.take(1).bind { [weak self] _ in
            guard let `self` = self else { return }
            guard let loginEntity = self.viewModel.ouptut.loginEntity.value else { return }
            
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            if let viewController = storyboard.instantiateViewController(identifier: "SignupViewController") as? SignupViewController {
                viewController.email = loginEntity.email
                viewController.delegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }.disposed(by: self.disposeBag)
        
        self.viewModel.ouptut.successedLogin.take(1).bind { [weak self] _ in
            guard let `self` = self else { return }
            
            self.delegate?.didSusccessLogin()
            self.dismiss(animated: true)
            
        }.disposed(by: self.disposeBag)
    }
}

extension LoginHomeViewController: SignupViewControllerDelegate {
    func didSusccessLoginSignup() {
        print("LoginNavigationController:: didSusccessLoginSignup")
        self.delegate?.didSusccessLogin()
    }
}
