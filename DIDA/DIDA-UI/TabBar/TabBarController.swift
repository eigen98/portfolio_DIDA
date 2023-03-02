//
//  TabBarController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class TabBarController: UIViewController {
    
    @IBOutlet weak var tabBar: TabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.background_black
        setTabBar()
    }
    
    func setTabBar() {
        self.tabBar.tabItems = ["좋아요한 NFT", "my NFT"]
        self.tabBar.delegate = self
    }
}

extension TabBarController: TabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
        print("selectedIndex: \(selectedIndex)")
    }
}
