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
    
    init(with step: PasswordStep, context: PasswordConfigurationContext, nftId: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = PasswordConfigurationViewModel(initialStep: step, context: context, nftId: nftId)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = PasswordConfigurationViewModel(initialStep: .setPassword, context: .initialSetup)
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
                self?.handlePasswordCheckState(state)
            })
            .disposed(by: disposeBag)
    }
    
    private func handlePasswordCheckState(_ state: PasswordCheckState) {
        switch state {
        case .initial:
            passwordConfigurationView.hideWrongCountLabel()
            
        case .matched:
            passwordConfigurationView.hideWrongCountLabel()
            handleMatchedPasswordState()
            
        case .mismatched(let count):
            handleMismatchedPasswordState(count)
            
        case .exceededLimit:
            handleExceededLimitState()
            
        case .passwordChanged:
            handlePasswordChangedState()
            
        case .error(let message):
            handleErrorState(message)
        }
    }
    
    private func handleMatchedPasswordState() {
        switch viewModel.context {
        case .nftPurchase(let nftId):
            navigateToNFTPurchaseViewController(nftId: nftId)
        case .coinSwap:
            performCoinSwap()
        default:
            break
        }
    }
    
    private func navigateToNFTPurchaseViewController(nftId: Int) {
        
        self.passwordConfigurationView.hideWrongCountLabel()
        guard let presentingVC = self.presentingViewController else { return }
        guard let nftId = self.viewModel.nftId else { return }
        let purchaseVC = NFTPurchaseViewController(currentNFTID: nftId)
        self.dismiss(animated: true, completion: { [weak presentingVC] in
            if let navController = presentingVC as? UINavigationController {
                navController.pushViewController(purchaseVC, animated: false)
            }
        })
    }

    private func performCoinSwap() {

    }

    private func handleMismatchedPasswordState(_ count: Int) {
        passwordConfigurationView.showWrongCountLabel(with: count)
        passwordConfigurationView.setTitle("비밀번호가 일치하지 않아요")
        passwordConfigurationView.setSubtitle("다시 눌러주세요")
    }

    private func handleExceededLimitState() {
        self.passwordConfigurationView.hideWrongCountLabel()
        let alertVC = PasswordChangeAlertViewController()
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: false)
    }

    private func handlePasswordChangedState() {
        guard let presentingVC = self.presentingViewController else { return }
        self.dismiss(animated: false,
                      completion: { [weak presentingVC] in
            presentingVC?.dismiss(animated: false)
        })
    }

    private func handleErrorState(_ message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
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
