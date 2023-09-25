//
//  BaseViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit

class BaseViewController: UIViewController {
    
    let customTitleBar = TitleBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBaseNavigationBar()
    }
    
    func bindViewModel() { }
    func bindEvent() { }
    
    func showError(error: Error) {
        // TODO: error catch -> showing toast
        print("error:: \(error)")
    }
    
    private func setBaseNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        configureCustomTitleBar(in: navigationController)
        setupBackButton()
    }
    
    private func configureCustomTitleBar(in navigationController: UINavigationController) {
        navigationController.navigationBar.addSubview(customTitleBar)
        view.bringSubviewToFront(customTitleBar)
        customTitleBar.backgroundColor = .black
        setCustomTitleBarConstraints(in: navigationController)
    }
    
    private func setCustomTitleBarConstraints(in navigationController: UINavigationController) {
        customTitleBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTitleBar.topAnchor.constraint(equalTo: navigationController.navigationBar.topAnchor),
            customTitleBar.leadingAnchor.constraint(equalTo: navigationController.navigationBar.leadingAnchor),
            customTitleBar.trailingAnchor.constraint(equalTo: navigationController.navigationBar.trailingAnchor),
            customTitleBar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupBackButton() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "left_arrows"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        customTitleBar.backgroundColor = .black
        customTitleBar.leftItems = [backButton]
    }
    
    @objc func backButtonTapped() {
        customTitleBar.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }

}
