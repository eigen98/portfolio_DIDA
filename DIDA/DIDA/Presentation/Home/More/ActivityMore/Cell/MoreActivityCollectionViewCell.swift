//
//  CollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import UIKit

class MoreActivityCollectionViewCell: UICollectionViewCell {

    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var articleCountLabel: UILabel!
    
    @IBOutlet weak var followButton: Buttons!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
