//
//  PostTableViewCell.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/26.
//

import UIKit

final class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var profileImageView: Profile!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var nftImageView: UIImageView!
    @IBOutlet weak var nftNameLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension PostTableViewCell {
    private func configure() {
        //프로필
        profileImageView.defaultImage()
        nameLabel.font = Fonts.bold_15
        
        //게시물
        postTitleLabel.font = Fonts.bold_16
        postBodyLabel.font = Fonts.regular_14
        
        //NFT 정보
        nftImageView.layer.cornerRadius = 6
        nftImageView.backgroundColor = Colors.brand_lemon_100 //임시
        nftNameLabel.font = Fonts.regular_14
        coinImageView.layer.cornerRadius = coinImageView.frame.size.width / 2
        coinImageView.backgroundColor = Colors.brand_ivory //임시
        priceLabel.font = Fonts.semi_bold_12
    }
}
