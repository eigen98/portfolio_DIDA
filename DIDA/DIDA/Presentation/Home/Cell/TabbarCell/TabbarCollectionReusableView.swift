//
//  TabbarCollectionReusableView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/24.
//

import UIKit
import RxSwift
class TabbarCollectionReusableView: UICollectionReusableView {
    
    var disposeBag = DisposeBag()
    private(set) var tabSelectedSubject = PublishSubject<Int>()
    var isClickedTabbar = false
    
    lazy var tabbar: ScrollableTabBar = {
        let tabbar = ScrollableTabBar()
        tabbar.width = 102
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    private func setupView() {
        addSubview(tabbar)
        setupConstraints()
        self.backgroundColor = .black
        setTabBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tabbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabbar.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: tabbar.bottomAnchor),
            trailingAnchor.constraint(equalTo: tabbar.trailingAnchor)
        ])
    }
    
    func setTabBar() {
        self.tabbar.tabItems = ["Hot Seller", "Sold Out", "최신 NFT", "활동"]
        self.tabbar.delegate = self
    }
}

extension TabbarCollectionReusableView: LineTabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
//        isClickedTabbar = true
       // self.tabbar.tabbarView.selectedSegmentIndex = selectedIndex

        tabSelectedSubject.onNext(selectedIndex)
        
        
    }
}
