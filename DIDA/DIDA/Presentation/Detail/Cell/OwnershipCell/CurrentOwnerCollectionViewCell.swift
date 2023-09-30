//
//  CurrentOwnerCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/30.
//

import UIKit

class CurrentOwnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.main.bounds.size.width
        containerHeightConstraint.constant = 92
        containerWidthConstraint.constant = width
        setupSeparator()
    }
    
    func configure(with owner: Owner) {
        dateLabel.text = owner.date
        userNameLabel.text = owner.userName
        priceLabel.text = owner.price
    }
    
    func setupSeparator() {
        let separatorHeight: CGFloat = 8.0
        let separator = CALayer()
        separator.backgroundColor = UIColor.separator.cgColor
        separator.frame = CGRect(x: 0, y: self.bounds.height - separatorHeight, width: self.bounds.width, height: separatorHeight)
        containerView.layer.addSublayer(separator)
    }

}
