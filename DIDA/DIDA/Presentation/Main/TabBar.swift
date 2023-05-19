//
//  MainTabBar.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/19.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func doChangedTab(button: UIButton) -> Bool
    func didTapButton(button: UIButton)
}

enum TabBarMenu: Int {
    case home = 0 
    case swap
    case make
    case community
    case mypage
    
    func toString() -> String? {
        switch self {
        case .home: return "홈"
        case .swap: return "스왑"
        case .make: return nil
        case .community: return "커뮤니티"
        case .mypage: return "마이페이지"
        }
    }
}

class TabBar: UIView {
    
    var buttonViews: [UIView] = []
    
    var selectedMenu: TabBarMenu?
    
    weak var delegate: TabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func toButton(at index: Int) -> TabBarItem? {
        var button: TabBarItem?
        
        for subview in buttonViews[index].subviews {
            if (subview is TabBarItem) {
                button = subview as? TabBarItem
            }
        }
        
        return button
    }
    
    private func setup() {
        if let stackview = self.subviews.first as? UIStackView {
            self.buttonViews = stackview.subviews
        }
        
        for index in 0..<buttonViews.count {
            let button = toButton(at: index)
            
            if (index == 0) {
                button?.isSelected = true
                self.selectedMenu = .home
            }
            
            button?.tabBarMenu = TabBarMenu.init(rawValue: index)
            button?.tag = index
            button?.addTarget(self, action: #selector(didTapButton(_: )), for: .touchUpInside)
        }
    }
    
    @objc public func didTapButton(_ button: UIButton?) {
        guard let button = button else { return }
        
        if let doChange = delegate?.doChangedTab(button: button) {
            if (doChange == false) {
                return
            }
        }
        
        selectedMenu = TabBarMenu.init(rawValue: button.tag)
        
        if (selectedMenu != .make) {
            selectedTab()
        }
        
        self.delegate?.didTapButton(button: button)
    }
    
    private func selectedTab() {
        guard let selectedMenu = selectedMenu else { return }
        
        for index in 0..<buttonViews.count {
            let button = toButton(at: index)
            
            if (index == selectedMenu.rawValue) {
                button?.isSelected = true
            } else {
                button?.isSelected = false
            }
        }
    }
}
