//
//  UIResponder+Extension.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/24.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            nextResponder = nextResponder?.next
        }
        return nil
    }
}
