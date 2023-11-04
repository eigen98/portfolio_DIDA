//
//  PasswordConfigurationViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/16.
//

import UIKit
import RxSwift

class PasswordConfigurationViewController: BaseViewController {

    private var viewModel = PasswordConfigurationViewModel()
    private let passwordConfigurationView = PasswordConfigurationView()
    private let disposeBag = DisposeBag()
    
    init(with step: PasswordStep, nftId: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PasswordConfigurationViewModel(initialStep: step, nftId: nftId)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = PasswordConfigurationViewModel(initialStep: .setPassword)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        passwordConfigurationView.numberButtonTapped
            .map{ "\($0)"}
            .bind(to: viewModel.input.numberButtonTapped)
            .disposed(by: disposeBag)
        
        passwordConfigurationView.deleteButtonTapped
            .bind(to: viewModel.input.deleteButtonTapped)
            .disposed(by: disposeBag)

        viewModel.showError
            .bind(onNext: { [weak self] error in
                
            })
            .disposed(by: disposeBag)
        
        viewModel.output.passwordStep
            .bind(onNext: { [weak self] step in
                switch step {
                case .setPassword:
                    self?.passwordConfigurationView.setTitle("지갑 비밀번호 설정")
                    self?.passwordConfigurationView.setSubtitle("NFT 거래 시 사용할 비밀번호를 설정해주세요.")
                    self?.passwordConfigurationView.resetInputViews()
                case .confirmSetPassword:
                    self?.passwordConfigurationView.setTitle("지갑 비밀번호 확인")
                    self?.passwordConfigurationView.setSubtitle("비밀번호를 다시 한번 입력해주세요.")
                    self?.passwordConfigurationView.resetInputViews()
                case .enterPassword:
                    self?.passwordConfigurationView.setTitle("지갑 비밀번호 입력")
                    self?.passwordConfigurationView.setSubtitle("내 지갑 비밀번호를 입력해주세요.")
                    self?.passwordConfigurationView.resetInputViews()
                case .changePassword:
                    self?.passwordConfigurationView.setTitle("새로운 비밀번호 입력")
                    self?.passwordConfigurationView.setSubtitle("지갑 비밀번호 변경을 위해 입력해주세요")
                    self?.passwordConfigurationView.resetInputViews()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.walletIssuedSuccessfully
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.passwordCheckState
            .bind(onNext: { [weak self] state in
                switch state {
                case .initial:
                    self?.passwordConfigurationView.hideWrongCountLabel()
                case .matched:
                    self?.passwordConfigurationView.hideWrongCountLabel()
                    
                    guard let presentingVC = self?.presentingViewController else { return }
                    guard let nftId = self?.viewModel.nftId else { return }
                    let purchaseVC = NFTPurchaseViewController(currentNFTID: nftId)
                    self?.dismiss(animated: true, completion: { [weak presentingVC] in
                        if let navController = presentingVC as? UINavigationController {
                            navController.pushViewController(purchaseVC, animated: false)
                        }
                    })
                    
                case .mismatched(let count):
                    self?.passwordConfigurationView.showWrongCountLabel(with: count)
                    self?.passwordConfigurationView.setTitle("비밀번호가 일치하지 않아요")
                    self?.passwordConfigurationView.setSubtitle("다시 눌러주세요")
                    
                case .exceededLimit:
                    self?.passwordConfigurationView.hideWrongCountLabel()
                    let alertVC = PasswordChangeAlertViewController()
                    alertVC.modalPresentationStyle = .overFullScreen
                    self?.present(alertVC, animated: false)
                case .passwordChanged:
                    guard let presentingVC = self?.presentingViewController else { return }
                    self?.dismiss(animated: false,
                                  completion: { [weak presentingVC] in
                        presentingVC?.dismiss(animated: false)
                    })
                case .error(let message):
                    break
                default:
                    break
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
