//
//  NftCardCollectionViewCell.swift
//  DIDA
//
//  Created by 김두리 on 2023/07/15.
//

import UIKit

class NftCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nftImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var nftNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nftPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
