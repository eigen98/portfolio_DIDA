//
//  BaseViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() { }
    func bindEvent() { }
    
    func showError(error: Error) {
        // TODO: error catch -> showing toast
        print("error:: \(error)")
    }
    
    func showLogin(delegate: LoginHomeViewControllerDelegate? = nil) {
        let storyBoard = UIStoryboard(name: "Auth", bundle: nil)
          
        if let controller = storyBoard.instantiateInitialViewController() {
//            if let delegate = delegate {
//                controller.delegate = delegate
//            }
            controller.modalPresentationStyle = .fullScreen
            
            self.topViewController()?.present(controller, animated: true)
        }
    }
}
