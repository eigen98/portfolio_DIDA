//
//  SellerCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/19.
//

import UIKit
//홈 뷰 TabbarCell의 유저 Cell입니다.
class SellerCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var sellerProfileImageView: UIImageView!
    
    @IBOutlet weak var sellerBackgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(seller : HotSellerEntity){
        if let profileURL = URL(string: seller.sellerProfile), let backgroundURL = URL(string: seller.sellerBacground) {
            self.sellerProfileImageView.kf.setImage(with: profileURL)
            self.sellerBackgroundImageView.kf.setImage(with: backgroundURL)
        }
        
        self.nameLabel.text = seller.sellerName
        
        
    }

}
