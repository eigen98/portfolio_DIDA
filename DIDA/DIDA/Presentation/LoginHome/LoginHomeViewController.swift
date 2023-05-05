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
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnKakao: UIButton!
    
    let viewModel = LoginHomeViewModel()
    let disposeBag = DisposeBag()
    
    weak var delegate: LoginHomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        self.btnKakao.setTitle("카카오톡으로 시작하기", for: .normal)
        self.btnApple.setTitle("Apple로 시작하기", for: .normal)
    }
    
    func bind() {
        // MARK: Input
        self.btnClose.rx.tap.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.dismiss(animated: true)
        }.disposed(by: self.disposeBag)
        
        self.btnApple.rx.tap.debounce(.milliseconds(1500), scheduler: MainScheduler.instance).bind(to: self.viewModel.input.tapAppleLoginButton).disposed(by: self.disposeBag)
        self.btnKakao.rx.tap.debounce(.milliseconds(1500), scheduler: MainScheduler.instance).bind(to: self.viewModel.input.tapKakaoLoginButton).disposed(by: self.disposeBag)
        
        // MARK: Output
        self.viewModel.showError.bind { [weak self] error in
            guard let `self` = self else { return }
            self.showError(error: error)
        }.disposed(by: self.disposeBag)
    }
}
