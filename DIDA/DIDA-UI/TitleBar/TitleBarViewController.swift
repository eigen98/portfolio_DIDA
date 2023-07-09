//
//  TitleBarViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/07/09.
//

import UIKit

class TitleBarViewController: UIViewController {
    
    @IBOutlet weak var titleBar1: TitleBar!
    @IBOutlet weak var titleBar2: TitleBar!
    @IBOutlet weak var titleBar3: TitleBar!
    
    public let closeButton: UIButton = {
        let button = UIButton.init(frame: .init(x: 0, y: 0, width: 28, height: 28))
        button.setImage(UIImage(named: "close"), for: .normal)
        return button
    }()
    
    public let logoButton: UILabel = {
        let label = UILabel()
        
        label.text = "DIDA"
        label.font = Fonts.bold_24
        label.textColor = Colors.text_white
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background_black
        setTitleBar1()
        setTitleBar2()
        setTitleBar3()
    }
    
    @objc func tapTitleItem1() {
        print("tapTitleItem1")
        
    }
    
    func setTitleBar1() {
        let custom1 = UIButton()
        custom1.setImage(UIImage(named: "send-plane-fill"), for: .normal)
        custom1.addTarget(self, action: #selector(tapTitleItem1), for: .touchUpInside)
        
        titleBar1.leftItems = [logoButton]
        titleBar1.rightItems = [custom1]
    }
    
    func setTitleBar2() {
        titleBar2.title = "프로필 수정"
        let custom1 = UIButton()
        custom1.setImage(UIImage(named: "Check"), for: .normal)
        
        titleBar2.leftItems = [closeButton, custom1]
    }
    
    func setTitleBar3() {
        
        let custom1 = UIButton()
        custom1.setImage(UIImage(named: "left_arrows"), for: .normal)
        
        let custom2 = Buttons.init(frame: .init(x: 0, y: 0, width: 30, height: 32))
        custom2.setTitle("팔로잉", for: .normal)
        custom2.buttonHeight = .h32
        custom2.style = .primary
        custom2.shape = .round
        
        titleBar3.leftItems = [custom1]
        
    }
}
