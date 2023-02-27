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
        
        for family in UIFont.familyNames {

                    let sName: String = family as String
                    print("family: \(sName)")
                            
                    for name in UIFont.fontNames(forFamilyName: sName) {
                        print("name: \(name as String)")
                    }
                }
    }
}

extension TabBarController: TabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
        print("selectedIndex: \(selectedIndex)")
    }
}
