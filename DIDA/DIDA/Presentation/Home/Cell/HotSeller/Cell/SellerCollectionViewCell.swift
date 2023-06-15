//
//  SellerCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/19.
//

import UIKit
//홈 뷰 TabbarCell의 유저 Cell입니다.
class SellerCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sellerProfileImageView: UIImageView!
    
    @IBOutlet weak var sellerBackgroundImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var moreButtonContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(seller : UserEntity){
        if seller.userId == -1 {
            self.containerView.isHidden = true
            configureLoadingView()
        }
        print("userId : \(seller.userId)")
        
        moreButtonContainerView.isHidden = true
        if let profileURL = URL(string: seller.profileImage ?? ""), let backgroundURL = URL(string: seller.profileImage ?? "") {
            self.sellerProfileImageView.kf.setImage(with: profileURL)
            self.sellerBackgroundImageView.kf.setImage(with: backgroundURL)
        }
        
        self.nameLabel.text = seller.nickname
       
        
    }
    
    func configureMoreButton(){
        moreButtonContainerView.isHidden = false
    }
    //스켈레톤 로딩뷰 보여주기
    func configureLoadingView(){
        self.contentView.startSkeletonAnimation()
    }
    
    func removeLottieAnimationView(){
        self.contentView.stopSkeletonAnimation()
    }

}
