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
}
