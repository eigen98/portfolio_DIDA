//
//  MoreHotSellerCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/26.
//

import UIKit

class MoreHotSellerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var nftCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var firstNFTImageView: UIImageView!
    
    @IBOutlet weak var secondNFTImageView: UIImageView!
    
    @IBOutlet weak var thirdNFTImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item : HotSellerEntity){
       
    }
    
    
    

}
