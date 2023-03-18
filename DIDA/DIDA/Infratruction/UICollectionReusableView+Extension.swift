//
//  UICollectionReusableView+Extension.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import Foundation

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
