//
//  ScrollableTabBar.swift
//  DIDA
//
//  Created by 김두리 on 2023/03/03.
//

import UIKit

class ScrollableTabBar: UIView, TabBarInterface {
    
    var selectedIndex: Int?
    
    var tabItems: [String] = [] {
        willSet(newVal) {
            setTabBarItems(items: newVal)
        }
    }
    
    var width: CGFloat = 0 {
        didSet {
            initialize()
        }
    }
    
    weak var delegate: TabBarDelegate?
    
    let scrollView = UIScrollView()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.surface_4
        return view
    }()
    
    private let indicator: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.brand_lemon
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(tabWidth: CGFloat) {
        self.init()
        self.width = tabWidth
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        
        [scrollView, indicator, divider].forEach { subview in
            self.addSubview(subview)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
                
        indicator.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.bottom.equalToSuperview()
            make.width.equalTo(self.frame.size.width)
            make.leading.equalTo(self.scrollView.snp.leading)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(1)
        }
        
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    public func moveTabItem(at selected : Int) {
        guard let subViews = self.stackView.subviews as? [UIButton] else { return }
        
        for button in subViews {
            if (button.tag == selected) {
                self.didChangePosition(button)
                break
            }
        }
    }
    
    @objc func didChangePosition(_ button: UIButton) {
        let index = button.tag
        
        self.selectedIndex = index
        let distance = self.width * CGFloat(index)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let `self` = self else { return }
            self.indicator.snp.updateConstraints { make in
                make.leading.equalTo(self.scrollView.snp.leading).offset(distance)
            }
            if (index == 0) {
                self.scrollView.setContentOffset(.init(x: 0, y: 0), animated: true)
            } else if (index == self.tabItems.count) {
                self.scrollView.setContentOffset(.init(x: self.scrollView.contentSize.width, y: 0), animated: true)
            }
            self.layoutIfNeeded()
        }
        
        self.updateButtonState()
        self.delegate?.didTapTabBarItem(selectedIndex: index)
    }
    
    private func setTabBarItems(items: [String]) {
        
        for index in 0..<items.count {
            let button = TabBarButton()
            button.tag = index
            button.buttonWidth = self.width
            button.setTitle(items[index], for: .normal)
            button.addTarget(self, action: #selector(didChangePosition(_:)), for: .touchUpInside)
            self.stackView.addArrangedSubview(button)
        }
        
        self.stackView.layoutIfNeeded()
        
        self.indicator.snp.updateConstraints { make in
            make.leading.equalTo(self.scrollView.snp.leading)
            make.width.equalTo(self.width)
        }
        
        if let button = self.stackView.subviews.first as? UIButton {
            self.didChangePosition(button)
        }
    }
    
    private func updateButtonState() {
        for subview in self.stackView.subviews {
            if let button = subview as? TabBarButton {
                button.isSelected = self.selectedIndex == button.tag
            }
        }
    }
}
