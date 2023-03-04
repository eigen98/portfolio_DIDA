//
//  CommentTableViewCell.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/26.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    enum CommentCellType: Int {
        case CommentCell
        case moreCell
    }
    
    static let identifier = "CommentTableViewCell"
    
    @IBOutlet weak var profileImageView: Profile!
    @IBOutlet weak var commentOuterView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}

extension CommentTableViewCell {
    private func configure() {
        //프로필
        profileImageView.defaultImage()
        //바깥뷰
        commentOuterView.layer.cornerRadius = commentOuterView.frame.size.height / 2
        //댓글
        commentLabel.font = Fonts.regular_14
    }
    
    func settingCell(_ type: CommentCellType, _ text: String) {
        switch type {
        case .CommentCell:
            commentOuterView.backgroundColor = Colors.surface_1
            profileImageView.isHidden = false
            commentLabel.textColor = Colors.text_white
        case .moreCell:
            commentOuterView.backgroundColor = Colors.background_black
            profileImageView.isHidden = true
            commentLabel.textColor = .darkGray //MARK: #939393
        }
        commentLabel.text = text
    }
}
