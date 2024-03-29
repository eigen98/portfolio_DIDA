//
//  MainViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit

class MainViewController: BaseViewController {
    @IBOutlet weak var tabBarView: TabBar!
    
    let viewModel: MainViewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarView.delegate = self
    }
    
    func showLogin() {
        let storyBoard = UIStoryboard(name: "Auth", bundle: nil)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "LoginHomeViewController") as? LoginHomeViewController {
            let navController = UINavigationController(rootViewController: controller)
            controller.delegate = self
            self.topViewController()?.present(navController, animated: true)
        }
    }
}

extension MainViewController: TabBarDelegate {
    func doChangedTab(button: UIButton) -> Bool {
        if let menu = TabBarMenu.init(rawValue: button.tag) {
            return menu == .make ? false : true
        }
        
        return false
    }
    
    func didTapButton(button: UIButton) {
        guard let tabBarViewController = self.children.first as? UITabBarController else { return }
        guard let selectedMenu = self.tabBarView.selectedMenu else { return }
        
        switch selectedMenu {
        case .make:
            break
        default:
            if (selectedMenu == .swap || selectedMenu == .mypage) {
                if (self.viewModel.isLogin == false) {
                    self.showLogin()
                    return
                }
            }
            
            if (selectedMenu.rawValue < TabBarMenu.make.rawValue) {
                tabBarViewController.selectedIndex = selectedMenu.rawValue
            } else {
                tabBarViewController.selectedIndex = selectedMenu.rawValue-1
            }
        }
    }
}

extension MainViewController: LoginHomeViewControllerDelegate {
    func didSusccessLogin() {
        print("LoginNavigationController:: didSusccessLogin")
        
        // 메인(홈)으로 이동
        
        let homeButton = self.tabBarView.toButton(at: TabBarMenu.home.rawValue)
        self.tabBarView.didTapButton(homeButton)
    }
}
