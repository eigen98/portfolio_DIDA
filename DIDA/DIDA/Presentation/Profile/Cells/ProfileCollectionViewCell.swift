//
//  ProfileCollectionViewCell.swift
//  DIDA
//
//  Created by 김두리 on 2023/07/15.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var nftButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nftButton.titleLabel?.font = Fonts.regular_18
        nftButton.titleLabel?.textColor = Colors.text_white
        nftButton.subtitleLabel?.font = Fonts.regular_14
        nftButton.subtitleLabel?.textColor = Colors.text_sub
        
        followerButton.titleLabel?.font = Fonts.regular_18
        followerButton.titleLabel?.textColor = Colors.text_white
        followerButton.subtitleLabel?.font = Fonts.regular_14
        followerButton.subtitleLabel?.textColor = Colors.text_sub
        
        followingButton.titleLabel?.font = Fonts.regular_18
        followingButton.titleLabel?.textColor = Colors.text_white
        followingButton.subtitleLabel?.font = Fonts.regular_14
        followingButton.subtitleLabel?.textColor = Colors.text_sub
    }

}
