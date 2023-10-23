//
//  PasswordChangeAlertViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class PasswordChangeAlertViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var passwordResetButton: UIButton!
    
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

        passwordResetButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let presentingVC = self?.presentingViewController else { return }
                self?.dismiss(animated: true, completion: { [weak presentingVC] in
                    let verificationCodeInputVC = VerificationCodeInputViewController()
                    verificationCodeInputVC.modalPresentationStyle = .fullScreen
                    presentingVC?.present(verificationCodeInputVC, animated: true, completion: nil)
                })
            })
            .disposed(by: disposeBag)
    }
}
