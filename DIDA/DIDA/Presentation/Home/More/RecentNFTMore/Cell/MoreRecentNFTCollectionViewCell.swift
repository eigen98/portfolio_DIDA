//
//  CollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/22.
//

import UIKit
import RxSwift
import RxCocoa
//최신 NFT 더보기 Cell
class MoreRecentNFTCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var nftNameLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    private var disposeBag = DisposeBag()

    
    var islike = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        islike = false
        itemImage.kf.cancelDownloadTask()
        self.hideSkeleton()
        disposeBag = DisposeBag()
    }
    
    func configure(item : NFTEntity){
        bind()
        if item == NFTEntity.loading{
            self.showSkeleton()
            return
        }
        itemImage.kf.setImage(with: URL(string: item.nftImg), placeholder: UIImage(systemName: "placeholder"))
        nftNameLabel.text = item.nftName
        userNameLabel.text = item.nickname
        priceLabel.text = item.price
        islike = item.liked
        toggleLikeImage()
    }
    
    
    private func toggleLikeImage() {
            let imageName = islike ? "heart-fill" : "heart-unfill"
            let image = UIImage(named: imageName)
            likeButton.setImage(image, for: .normal)
        }
    
    
    private func bind(){
        likeButton.rx.tap
            .bind { [weak self] in
                self?.islike.toggle()
                self?.toggleLikeImage()
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    

}
