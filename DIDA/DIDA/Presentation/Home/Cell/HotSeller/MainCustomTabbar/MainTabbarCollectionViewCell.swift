//
//  MainTabbarCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/19.
//

import UIKit
//탭바 셀
class MainTabbarCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Tab"
        label.textAlignment = .center
        
        label.font = Fonts.regular_16
        label.textColor = UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var notSelectedColor = UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 1)
    
    override var isSelected: Bool {
        didSet{
            print("Changed")
            self.label.textColor = isSelected ? Colors.brand_lemon : notSelectedColor
            self.label.font = isSelected ? Fonts.bold_16 : Fonts.regular_16
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(label)
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       }

}
