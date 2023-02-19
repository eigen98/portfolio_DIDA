//
//  TabBarItem.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/19.
//

import UIKit

class TabBarItem: UIButton {
    
    var tabBarMenu: TabBarMenu? {
        willSet {
            if let menu = newValue {
                setup(menu)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(_ menu: TabBarMenu) {
        switch menu {
        case .home:
            self.setImage(UIImage.init(named: "home-5-line"), for: .normal)
            self.setImage(UIImage.init(named: "home-5-line")?.withTintColor(.white), for: .selected)
        case .swap:
            self.setImage(UIImage.init(named: "exchange-dollar-line"), for: .normal)
            self.setImage(UIImage.init(named: "exchange-dollar-line")?.withTintColor(.white), for: .selected)
        case .make:
            self.setImage(UIImage.init(named: "tabbar-plus"), for: .normal)
        case .community:
            self.setImage(UIImage.init(named: "question-answer-line"), for: .normal)
            self.setImage(UIImage.init(named: "question-answer-line")?.withTintColor(.white), for: .selected)
        case .mypage:
            self.setImage(UIImage.init(named: "emotion-happy-line"), for: .normal)
            self.setImage(UIImage.init(named: "emotion-happy-line")?.withTintColor(.white), for: .selected)
        }
        
        self.setTitle(menu.toString(), for: .normal)
        self.titleLabel?.font = Fonts.regular_10
        self.centering()
    }
    
    private func centering() {
        let titleSize = self.titleLabel?.frame.size ?? .zero
        let imageSize = self.imageView?.frame.size  ?? .zero
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height),left: 0, bottom: 0, right:  -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height), right: 0)
     }
}
