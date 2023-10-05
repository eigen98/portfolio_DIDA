//
//  NFTOverviewCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import UIKit

protocol NFTOverviewCollectionViewCellDelegate: AnyObject {
    func didTapFollowButton(onCell cell: NFTOverviewCollectionViewCell)
}

class NFTOverviewCollectionViewCell: UICollectionViewCell {
    
    struct Constants {
        static let separatorHeight: CGFloat = 8.0
    }
    weak var delegate: NFTOverviewCollectionViewCellDelegate?
    
    @IBOutlet weak var nftImageView: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nftNameLabel: UILabel!
    
    @IBOutlet weak var nftDescriptionLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var followButton: Buttons!
    
    private let separator = CALayer()
    
    private var isFollowing = false {
        didSet{
            configureFollowButton(isFollowing: isFollowing)
        }
    }
    
    
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
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateSeparatorFrame()
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
        self.isFollowing = data.followed
        configureFollowButton(isFollowing: data.followed)
    }
    
    private func configureFollowButton(isFollowing: Bool) {
        followButton.style = isFollowing ? .primary : .dialog
        followButton.shape = .circle
        let text = isFollowing ? "팔로잉" : "팔로우"
        followButton.setTitle(text, for: .normal)
        let color = isFollowing ? UIColor.black : UIColor.white
        followButton.customTitleColor = .init(normal: color, disabled: color, selected: color, hightlight: color)
    }
    
    @IBAction func followButtonTapped(_ sender: Buttons) {
        delegate?.didTapFollowButton(onCell: self)
        isFollowing.toggle()
    }
    
    
    
    func setupSeparator() {
        separator.backgroundColor = Colors.surface_1?.cgColor
        separator.frame = CGRect(x: 0,
                                 y: self.bounds.height - Constants.separatorHeight,
                                 width: self.bounds.width,
                                 height: Constants.separatorHeight)
        self.layer.addSublayer(separator)
    }
    
    func updateSeparatorFrame() {
        separator.frame = CGRect(x: 0,
                                 y: bounds.height - Constants.separatorHeight,
                                 width: bounds.width,
                                 height: Constants.separatorHeight)
    }
}
