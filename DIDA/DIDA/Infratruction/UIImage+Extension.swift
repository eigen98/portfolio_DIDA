//
//  UIImage+Extension.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/26.
//

import UIKit

extension UIImage {
    static func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        return img
    }
}
