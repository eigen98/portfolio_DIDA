//
//  ButtonsViewController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/25.
//

import UIKit

class ButtonsViewController: UIViewController {
    
    @IBOutlet weak var btnStyle1: Buttons!
    @IBOutlet weak var btnStyle2: Buttons!
    @IBOutlet weak var btnStyle3: Buttons!
    
    @IBOutlet weak var btnShape1: Buttons!
    @IBOutlet weak var btnShape2: Buttons!
    @IBOutlet weak var btnShape3: Buttons!
    
    @IBOutlet weak var btnH32: Buttons!
    @IBOutlet weak var btnH36: Buttons!
    @IBOutlet weak var btnH44: Buttons!
    @IBOutlet weak var btnH48: Buttons!
    @IBOutlet weak var btnH52: Buttons!
    @IBOutlet weak var btnH56: Buttons!
    
    @IBOutlet weak var btnDisabled: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyles()
        setShapes()
        setHeight()
    }
    
    
    @IBAction func didTapDisabled(_ sender: Any) {
        self.btnStyle1.isEnabled = !self.btnStyle1.isEnabled
        self.btnStyle2.isEnabled = !self.btnStyle2.isEnabled
        self.btnStyle3.isEnabled = !self.btnStyle3.isEnabled
        
        self.btnShape1.isEnabled = !self.btnShape1.isEnabled
        self.btnShape2.isEnabled = !self.btnShape2.isEnabled
        self.btnShape3.isEnabled = !self.btnShape3.isEnabled
        
    }
    
    private func setStyles() {
        self.btnStyle1.style = .primary
        self.btnStyle1.buttonHeight = .h32
        
        self.btnStyle2.style = .dark
        self.btnStyle2.buttonHeight = .h32
        
        
        let customSet = ButtonStateToColor(normal: Colors.brand_lemon_400, disabled: Colors.brand_lemon_100, selected: Colors.brand_lemon_300, hightlight: Colors.brand_lemon_1000)
        self.btnStyle3.style = .custom(customSet)
    }
    
    private func setShapes() {
        self.btnShape1.shape = .suquare
        self.btnShape1.style = .dark
        self.btnShape1.buttonHeight = .h32
        
        self.btnShape2.shape = .round
        self.btnShape2.style = .dark
        self.btnShape2.buttonHeight = .h32
        
        self.btnShape3.shape = .circle
        self.btnShape3.style = .dialog
        self.btnShape3.buttonHeight = .h32
    }
    
    private func setHeight() {
        self.btnH32.shape = .suquare
        self.btnH32.style = .dark
        self.btnH32.buttonHeight = .h32
        
        self.btnH36.shape = .suquare
        self.btnH36.style = .dark
        self.btnH36.buttonHeight = .h36
        
        self.btnH44.shape = .suquare
        self.btnH44.style = .dark
        self.btnH44.buttonHeight = .h44
        
        self.btnH48.shape = .suquare
        self.btnH48.style = .dark
        self.btnH48.buttonHeight = .h48
        
        self.btnH52.shape = .suquare
        self.btnH52.style = .dark
        self.btnH52.buttonHeight = .h52
        
        self.btnH56.shape = .suquare
        self.btnH56.style = .dark
        self.btnH56.buttonHeight = .h56
    }
}
