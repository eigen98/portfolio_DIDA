//
//  TabBarButton.swift
//  DIDA
//
//  Created by 김두리 on 2023/03/03.
//

import UIKit

class TabBarButton: UIButton {
    
    var buttonWidth: CGFloat = 105 {
        didSet {
            setWidth()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setSelected()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = nil
        
        self.setTitleColor(Colors.brand_lemon, for: .selected)
        self.setTitleColor(Colors.surface_6, for: .normal)
    }
    
    private func setWidth() {
        self.snp.makeConstraints { make in
            make.width.equalTo(self.buttonWidth)
        }
    }
    
    private func setSelected() {
        if (self.isSelected) {
            self.titleLabel?.font = Fonts.bold_16
        } else {
            self.titleLabel?.font = Fonts.medium_16
        }
    }
    
}

