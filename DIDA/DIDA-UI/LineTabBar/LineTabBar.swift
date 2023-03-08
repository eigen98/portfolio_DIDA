//
//  TabBar.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

protocol LineTabBarDelegate: AnyObject {
    func didTapTabBarItem(selectedIndex: Int)
}

protocol LineTabBarInterface {
    var delegate: LineTabBarDelegate? { get set }
    
    var selectedIndex: Int? { get set }
    var tabItems: [String] { get set }
}

class LineTabBar: UIView, LineTabBarInterface {
    
    weak var delegate: LineTabBarDelegate?
    
    var selectedIndex: Int?
    
    var tabItems: [String] = [] {
        willSet(newVal) {
            setTabBarItems(items: newVal)
        }
    }
    
    let tabbarView: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.backgroundColor = .clear
        segment.selectedSegmentTintColor = .clear
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Colors.surface_6 ?? .lightGray,
            NSAttributedString.Key.font: Fonts.medium_16 ?? .systemFont(ofSize: 16)
        ], for: .normal)
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: Colors.brand_lemon ?? .systemYellow,
            NSAttributedString.Key.font: Fonts.bold_16 ?? .systemFont(ofSize: 16)
        ], for: .selected)
        
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
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
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        
        [tabbarView, indicator, divider].forEach { subview in
            self.addSubview(subview)
        }
        
        tabbarView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
                
        indicator.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.bottom.equalToSuperview()
            make.width.equalTo(120)
            make.leading.equalTo(self.tabbarView.snp.leading)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(1)
        }
        
        self.tabbarView.addTarget(self, action: #selector(didChangePosition), for: .valueChanged)
    }
    
    @objc func didChangePosition() {
        let selectedIndex = CGFloat(self.tabbarView.selectedSegmentIndex)
        let width = self.tabbarView.frame.width / CGFloat(self.tabbarView.numberOfSegments)
        let distance = width * selectedIndex
        
        self.selectedIndex = Int(selectedIndex)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let `self` = self else { return }
            self.indicator.snp.updateConstraints { make in
                make.leading.equalTo(self.tabbarView.snp.leading).offset(distance+30)
            }
            self.layoutIfNeeded()
        }
        
        self.delegate?.didTapTabBarItem(selectedIndex: Int(selectedIndex))
    }
    
    private func setTabBarItems(items: [String]) {
        for index in 0..<items.count {
            self.tabbarView.insertSegment(withTitle: items[index], at: index, animated: true)
        }
        
        self.indicator.snp.updateConstraints { make in
            make.leading.equalTo(self.tabbarView.snp.leading).offset(30)
        }
        
        self.tabbarView.selectedSegmentIndex = 0
        self.didChangePosition()
    }
}
