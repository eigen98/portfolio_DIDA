//
//  LineTabBarController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class LineTabBarController: UIViewController {
    
    @IBOutlet weak var tabBar: LineTabBar!
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
    }
    
    func setTabBar() {
        self.tabBar.tabItems = ["좋아요한 NFT", "my NFT"]
        self.tabBar.delegate = self
    }
}

extension LineTabBarController: LineTabBarDelegate {
    func didTapTabBarItem(selectedIndex: Int) {
        print("selectedIndex: \(selectedIndex)")
    }
}
