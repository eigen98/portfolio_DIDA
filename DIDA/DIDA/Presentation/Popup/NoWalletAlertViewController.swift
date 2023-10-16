//
//  NoWalletAlertViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/11.
//

import UIKit
import RxSwift
import RxCocoa

class NoWalletAlertViewController: BaseViewController {

    
    @IBOutlet weak var goToSetPasswordButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindEvent()
    }
    
    override func bindEvent() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        goToSetPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let presentingVC = self?.presentingViewController else { return }
                self?.dismiss(animated: true, completion: { [weak presentingVC] in
                    let passwordConfigurationVC = PasswordConfigurationViewController()
                    passwordConfigurationVC.modalPresentationStyle = .fullScreen
                    presentingVC?.present(passwordConfigurationVC, animated: true, completion: nil)
                })
            })
            .disposed(by: disposeBag)
    }
}
