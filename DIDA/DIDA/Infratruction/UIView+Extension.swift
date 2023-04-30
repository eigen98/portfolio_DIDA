//
//  UIView+Extension.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/30.
//

import Foundation
import UIKit

extension UIView {
    //스켈레톤 로딩 뷰 보여주기 함수
    func startSkeletonAnimation(cornerRadius: CGFloat = 10.0) {
        self.backgroundColor = UIColor(red: 0.173, green: 0.173, blue: 0.173, alpha: 1)

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(white: 0.25, alpha: 1.0).cgColor,
            UIColor(white: 0.45, alpha: 1.0).cgColor,
            UIColor(white: 0.25, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        gradientLayer.frame = self.bounds
        gradientLayer.name = "SkeletonAnimationLayer"

        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 1.5
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity

        gradientLayer.add(animation, forKey: "SkeletonAnimation")
        self.layer.addSublayer(gradientLayer)
    }

    func stopSkeletonAnimation() {
        guard let sublayers = self.layer.sublayers else { return }
        for layer in sublayers {
            if layer.name == "SkeletonAnimationLayer" {
                layer.removeFromSuperlayer()
            }
        }
        self.backgroundColor = UIColor.clear
    }
}
