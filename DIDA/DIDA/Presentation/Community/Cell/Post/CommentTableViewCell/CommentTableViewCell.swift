//
//  CommentTableViewCell.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/26.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentOuterView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CommentTableViewCell {
    private func configure() {
        //프로필 이미지 -> 나중에 컴포넌트로 변경
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        //바깥뷰
        commentOuterView.layer.cornerRadius = commentOuterView.frame.size.height / 2
        
        //댓글
        commentLabel.font = Fonts.regular_14
    }
}
