//
//  TabBarController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class TabBarController: UIViewController {
    
    @IBOutlet weak var tabBar: TabBar!
    @IBOutlet weak var tabBar2: ScrollableTabBar! {
        didSet {
            tabBar2.width = 102
        }
    }
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background_black
        setTabBar()
        setTabBar2()
    }
    
    func setTabBar() {
        self.tabBar.tabItems = ["좋아요한 NFT", "my NFT"]
        self.tabBar.delegate = self
        self.button1.addTarget(self, action: #selector(goToindex1ByTabBar1), for: .touchUpInside)
    }
    
    func setTabBar2() {
        self.tabBar2.tabItems = [
            "Hot Seller", "Sold Out", "최신 NFT", "활동", "NFT"
        ]
        self.tabBar2.delegate = self
        
        self.button2.addTarget(self, action: #selector(goToindex2ByTabBar2), for: .touchUpInside)
    }
    
    @objc func goToindex1ByTabBar1() {
        self.tabBar.moveTabItem(at: 1)
    }
    
    @objc func goToindex2ByTabBar2() {
        self.tabBar2.moveTabItem(at: 2)
    }
}

extension TabBarController: TabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
        print("selectedIndex: \(selectedIndex)")
    }
}
