//
//  AppDelegate.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/14.
//

import UIKit
import KakaoSDKAuth
import SkeletonView

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeUserSession()
        configureSkeletonAppearance()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleOpenUrl(url: url)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // This function is empty, consider removing it if not needed.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    // MARK: - Helper Methods
    
    private func initializeUserSession() {
        UserSession.shared.initialize()
    }
    
    private func configureSkeletonAppearance() {
        let appearance = SkeletonAppearance.default
        appearance.tintColor = Colors.skeleton_surface ?? .red
        SkeletonAppearance.default = appearance
    }
    
    private func handleOpenUrl(url: URL) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
