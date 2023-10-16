//
//  PasswordConfigurationViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/16.
//

import UIKit
import RxSwift

class PasswordConfigurationViewController: BaseViewController {

    
    private let viewModel = PasswordConfigurationViewModel()
    private let passwordConfigurationView = PasswordConfigurationView()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        passwordConfigurationView.numberButtonTapped
            .bind(onNext: viewModel.numberButtonTapped)
            .disposed(by: disposeBag)

        passwordConfigurationView.deleteButtonTapped
            .bind(onNext: viewModel.deleteButtonTapped)
            .disposed(by: disposeBag)

        viewModel.showError
            .bind(onNext: { [weak self] error in
                
            })
            .disposed(by: disposeBag)
        
        viewModel.passwordStep
            .bind(onNext: { [weak self] step in
                switch step {
                case .setPassword:
                    self?.passwordConfigurationView.setTitle("지갑 비밀번호 설정")
                    self?.passwordConfigurationView.setSubtitle("NFT 거래 시 사용할 비밀번호를 설정해주세요.")
                case .confirmSetPassword:
                    self?.passwordConfigurationView.setTitle("지갑 비밀번호 확인")
                    self?.passwordConfigurationView.setSubtitle("비밀번호를 다시 한번 입력해주세요.")
                case .enterPassword:
                    self?.passwordConfigurationView.setTitle("지갑 비밀번호 입력")
                    self?.passwordConfigurationView.setSubtitle("내 지갑 비밀번호를 입력해주세요.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {

        passwordConfigurationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordConfigurationView)
        setupConstraints()
    }
    
    private func setupConstraints() {
       
        passwordConfigurationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        passwordConfigurationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        passwordConfigurationView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        passwordConfigurationView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
