//
//  MyPageViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit

class MyPageViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleBar()
    }
    private func setTitleBar() {
        let walletButton = UIButton()
        walletButton.setImage(UIImage(named: "wallet-line"), for: .normal)
        walletButton.addTarget(self, action: #selector(walletButtonTapped), for: .touchUpInside)
        customTitleBar.rightItems = [walletButton]
    }
    
    @objc func walletButtonTapped() {
        
    }
}
