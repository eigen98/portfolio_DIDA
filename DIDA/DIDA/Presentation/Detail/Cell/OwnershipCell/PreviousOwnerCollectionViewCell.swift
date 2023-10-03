//
//  PreviousOwnerCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/30.
//

import UIKit

class PreviousOwnerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = UIScreen.main.bounds.size.width
        containerHeightConstraint.constant = 72
        containerWidthConstraint.constant = width
        
        setupSeparator()
    }

    func configure(with owner: Owner) {
        dateLabel.text = owner.date
        userNameLabel.text = owner.userName
        priceLabel.text = owner.price
        
       
    }

    func setupSeparator() {
        let separatorHeight: CGFloat = 1.0
        let separator = CALayer()
        separator.backgroundColor = Colors.border_line?.cgColor
        separator.frame = CGRect(x: 0, y: self.bounds.height - separatorHeight, width: self.bounds.width, height: separatorHeight)
        self.layer.addSublayer(separator)
    }

}
