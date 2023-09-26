//
//  UIViewController+Extension.swift
//  DIDA
//
//  Created by 김두리 on 2023/04/15.
//

import UIKit

extension UIViewController {
    func topViewController() -> UIViewController? {
        return self.navigationController?.topViewController
    }

    func showLoadingBlocker() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }
        
        LoadingBlockerView.shared.frame = window.bounds
        window.addSubview(LoadingBlockerView.shared)
    }

    func hideLoadingBlocker() {
        LoadingBlockerView.shared.removeFromSuperview()
    }
}
