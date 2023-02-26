//
//  Profile.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/26.
//

import UIKit
import Kingfisher

class Profile: UIView {
    
    var imageView: UIImageView = .init()
    var borderColor: UIColor? = .clear {
        willSet(newVal) {
            self.layer.borderColor = newVal?.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
        self.imageView = .init(frame: self.frame)
        self.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.layer.borderColor = self.borderColor?.cgColor
        self.layer.borderWidth = 2.3
    }
    
    func load(urlString: String?) {
        
        if let urlString = urlString, let url = URL.init(string: urlString) {
            self.imageView.kf.setImage(with: url)
        } else {
            self.defaultImage()
        }
    }
    
    func defaultImage() {
        self.backgroundColor = Colors.surface_1
    }
}
