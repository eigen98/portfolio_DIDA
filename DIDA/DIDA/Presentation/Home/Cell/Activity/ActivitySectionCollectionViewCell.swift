//
//  ActivitySectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/09.
//

import UIKit

class ActivitySectionCollectionViewCell: UICollectionViewCell {

    //첫번째 유저 프로필
    
    @IBOutlet weak var firstItemContainerView: UIView!
    
    @IBOutlet weak var firstItemImageView: UIImageView!
    
    @IBOutlet weak var firstItemNameLabel: UILabel!
    
    @IBOutlet weak var firstItemCountLabel: UILabel!
    
    
    @IBOutlet weak var firstFollowButton: Buttons!
    
    //두번째 유저 프로필
    
    @IBOutlet weak var secondItemContainerView: UIView!
    
    @IBOutlet weak var secondItemImageView: UIImageView!
    
    @IBOutlet weak var secondItemNameLabel: UILabel!
    
    @IBOutlet weak var secondItemCountLabel: UILabel!
    
    @IBOutlet weak var secondFollowButton: Buttons!
    
   
    
    //세번째 유저 프로필
    
    
    @IBOutlet weak var thirdItemContainerView: UIView!
    
    @IBOutlet weak var thirdItemImageView: UIImageView!
    
    @IBOutlet weak var thirdItemNameLabel: UILabel!
    
    @IBOutlet weak var thirdItemCountLabel: UILabel!
    
    @IBOutlet weak var thirdFollowButton: Buttons!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButtons()

    }
    
    
    func configure(items: [HotUserEntity]) {
        clearViews()
        
        for (index, item) in items.enumerated() {
            if index == 0 {
                firstItemContainerView.isHidden = false
                configureView(firstItemImageView, firstItemNameLabel, firstItemCountLabel, item)
            } else if index == 1 {
                secondItemContainerView.isHidden = false
                configureView(secondItemImageView, secondItemNameLabel, secondItemCountLabel, item)
            } else if index == 2 {
                thirdItemContainerView.isHidden = false
                configureView(thirdItemImageView, thirdItemNameLabel, thirdItemCountLabel, item)
            }
        }
    }
    
    private func configureView(_ imageView: UIImageView, _ nameLabel: UILabel, _ countLabel: UILabel, _ item: HotUserEntity) {
           if let url = URL(string: item.profileUrl) {
               imageView.kf.setImage(with: url)
           }
           nameLabel.text = item.name
           countLabel.text = "\(item.count) 작품"
    }
    
    private func clearViews() {
        firstItemContainerView.isHidden = true
        secondItemContainerView.isHidden = true
        thirdItemContainerView.isHidden = true
        
        firstItemImageView.image = nil
        firstItemNameLabel.text = nil
        firstItemCountLabel.text = nil
        
        secondItemImageView.image = nil
        secondItemNameLabel.text = nil
        secondItemCountLabel.text = nil
        
        thirdItemImageView.image = nil
        thirdItemNameLabel.text = nil
        thirdItemCountLabel.text = nil
    }
    
    private func configureButtons() {
        let buttons = [firstFollowButton, secondFollowButton, thirdFollowButton]
        buttons.forEach {
            $0?.style = .dialog
            $0?.shape = .circle
            $0?.buttonHeight = .h32
            $0?.customTitleColor = .init(normal: .white, disabled: .white, selected: .white, hightlight: .white)
        }
    }
    
}
