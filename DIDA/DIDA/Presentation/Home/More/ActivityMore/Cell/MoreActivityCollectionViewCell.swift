//
//  CollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import UIKit
import RxSwift
class MoreActivityCollectionViewCell: UICollectionViewCell {

    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var articleCountLabel: UILabel!
    
    @IBOutlet weak var followButton: Buttons!
    
    var isFollowed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isFollowed = false
        profileImageView.kf.cancelDownloadTask()
        disposeBag = DisposeBag()
    }
    
    func configure(item : MoreActivityEntity){
        bind()
        profileImageView.kf.setImage(with: URL(string: item.profileUrl), placeholder: UIImage(systemName: "placeholder"))
        userNameLabel.text = item.name
        articleCountLabel.text = "\(item.cardCnt) 작품"
        configureButton()
        self.isFollowed = item.followed
        configureButton()
    }
    
    private func configureButton() {
        followButton.shape = .circle
        followButton.buttonHeight = .h32
        
        if isFollowed{
            followButton.style = .dialog
            followButton.setTitle("팔로우", for: .normal)
            followButton.customTitleColor = .init(normal: .white, disabled: .white, selected: .white, hightlight: .white)
        }else{
            followButton.setTitle("팔로잉", for: .normal)
            followButton.style = .primary
            followButton.customTitleColor = .init(normal: .black, disabled: .white, selected: .white, hightlight: .white)
        }
        
        
        
    }
    
    private func bind(){
        followButton.rx.tap
            .bind { [weak self] in
                print("tap")
                self?.isFollowed.toggle()
                self?.configureButton()
            }
            .disposed(by: disposeBag)
    }

}
