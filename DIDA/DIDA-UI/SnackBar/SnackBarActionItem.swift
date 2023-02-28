//
//  SnackBarActionItem.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class SnackBarActionItem: Buttons {
    var title: String = ""
    var isDefault: Bool = false
    var action: (() -> Void)?
    
    convenience init(title: String, isDefault: Bool, action: (() -> Void)?) {
        self.init()
        
        self.title = title
        self.isDefault = isDefault
        self.action = action
        
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        self.buttonHeight = .h56
        self.shape = .round
        self.style = isDefault ? .primary : .dark
        
        self.setTitle(self.title, for: .normal)
        
        self.addTarget(self, action: #selector(didTapActionButton), for: .touchUpInside)
    }
    
    @objc private func didTapActionButton() {
        self.action?()
    }
}


