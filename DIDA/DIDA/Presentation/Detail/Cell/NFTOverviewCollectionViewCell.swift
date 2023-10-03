//
//  NFTOverviewCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import UIKit

class NFTOverviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nftImageView: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nftNameLabel: UILabel!
    
    @IBOutlet weak var nftDescriptionLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var followButton: Buttons!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = UIScreen.main.bounds.size.width
        imageWidthConstraint.constant = width
        imageHeightConstraint.constant = width
        setupSeparator()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
    }
    
    func configure(with data: OverviewData?) {
        
        guard let data = data else {
            showSkeleton()
            return
        }
        hideSkeleton()

        if let url = URL(string: data.nftImageUrl) {
            nftImageView.kf.setImage(with: url)
        } else {
            nftImageView.image = UIImage(named: "placeholder")
        }
        nftNameLabel.text = data.nftName
        nftDescriptionLabel.text = data.description
        userNameLabel.text = data.memberName
        nftImageView.kf.setImage(with: URL(string: data.nftImageUrl))
        userImageView.kf.setImage(with: URL(string: data.memberImageUrl))
    }
    
    func setupSeparator() {
        let separatorHeight: CGFloat = 8.0
        let separator = CALayer()
        separator.backgroundColor = UIColor.separator.cgColor
        separator.frame = CGRect(x: 0, y: self.bounds.height - separatorHeight, width: self.bounds.width, height: separatorHeight)
        self.layer.addSublayer(separator)
    }
    
    
    
}
