//
//  LoginHomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import UIKit

protocol LoginHomeViewControllerDelegate: AnyObject {
    func didSusccessLogin()
}

class LoginHomeViewController: BaseViewController {
    
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnKakao: UIButton!
    
    weak var delegate: LoginHomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        self.btnKakao.setTitle("카카오톡으로 시작하기", for: .normal)
        self.btnApple.setTitle("Apple로 시작하기", for: .normal)
    }
}
