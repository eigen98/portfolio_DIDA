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
    private var loadingView: UIView = {
        var view = UIView()
        view.skeletonCornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        view.isUserInteractionEnabled = false
       return view
    }()
    
    lazy var tabbar: ScrollableTabBar = {
        let tabbar = ScrollableTabBar()
        tabbar.width = 102
        tabbar.isSkeletonable = true
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
        addSubview(loadingView)
        setupConstraints()
        self.backgroundColor = .black
        setTabBar()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tabbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabbar.topAnchor.constraint(equalTo: topAnchor),
            tabbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            tabbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabbar.heightAnchor.constraint(equalToConstant: 44),
            
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor ,
                                                 constant: 16),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -16),
            loadingView.topAnchor.constraint(equalTo: topAnchor,
                                             constant: 0),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                constant: 0)
            
        ])
        
    }
    
    func setTabBar() {
        self.tabbar.tabItems = ["Hot Seller", "Sold Out", "최신 NFT", "활동"]
        self.tabbar.delegate = self
    }
    
    //스켈레톤 로딩뷰 보여주기
    func configureLoadingView(){
        tabbar.isHidden = true
        loadingView.isHidden = false
        loadingView.showSkeleton()
        
    }
    
    func removeLoadingView(){
        tabbar.isHidden = false
        loadingView.isHidden = true
        loadingView.hideSkeleton()
        
    }
}

extension TabbarCollectionReusableView: LineTabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
        tabSelectedSubject.onNext(selectedIndex)
    }
}
