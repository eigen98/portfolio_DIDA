//
//  TabbarCollectionReusableView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/24.
//

import UIKit
import RxSwift
class TabbarCollectionReusableView: UICollectionReusableView {
    
    private let disposeBag = DisposeBag()
    private var currentTabIndex: Int = 0
    private(set) var tabSelectedSubject = PublishSubject<Int>()
    var isLoading = false
    
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

    func updateTabBarToIndex(_ index: Int) {
        if currentTabIndex != index {
            self.tabbar.moveTabItem(at: index)
            currentTabIndex = index
        }
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
    
    //스켈레톤 로딩뷰 보여주기
    func configureLoadingView(){
        
        let loadingView = UIView()
        loadingView.frame = self.frame
        self.addSubview(loadingView)
//        loadingView.startSkeletonAnimation()
    }
    
    func removeLottieAnimationView(){
        //self.contentView.stopSkeletonAnimation()
    }
}

extension TabbarCollectionReusableView: LineTabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
        tabSelectedSubject.onNext(selectedIndex)
    }
}
