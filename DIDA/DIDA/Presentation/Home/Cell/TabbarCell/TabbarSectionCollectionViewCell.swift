//
//  TabbarSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit

class TabbarSectionCollectionViewCell: UICollectionViewCell {
    
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setTabBar()
        
        
    }
    
    func setTabBar() {
        
        self.contentView.backgroundColor = .yellow
    }

}

