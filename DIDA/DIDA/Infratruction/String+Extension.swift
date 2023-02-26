//
//  String+Extension.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/26.
//

import Foundation
import UIKit

extension String {
    
    func widthWithFont(font: UIFont) -> CGFloat {
        let string = self as NSString
        return string.size(withAttributes: [.font: font]).width
    }
    
    func hegihtWithFont(font: UIFont) -> CGFloat {
        let string = self as NSString
        return string.size(withAttributes: [.font: font]).height
    }
}
