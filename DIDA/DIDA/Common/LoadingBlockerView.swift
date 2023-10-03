//
//  LoadingBlockerView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/26.
//

import UIKit

class LoadingBlockerView: UIView {
    static let shared = LoadingBlockerView()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
