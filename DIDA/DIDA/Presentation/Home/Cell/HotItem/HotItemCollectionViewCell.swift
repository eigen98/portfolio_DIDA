//
//  HotItemCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/18.
//

import UIKit
import RxSwift

//HOT Item 리스트 컬렉션뷰 셀
class HotItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nftNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var heartCountLabel: UILabel!
    //Button 뷰
    @IBOutlet weak var heartContainerView: UIView!
    
    var disposeBag = DisposeBag()
    
    var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    //셀이 화면 밖으로 스크롤되어 더 이상 보이지 않을 때와 같이 셀을 재사용하려고 할 때 호출
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        isLiked = false
    }
    
    func configure(item: HotItemEntity) {
        imageView.kf.setImage(with: URL(string: item.nftImg), placeholder: UIImage(systemName: "placeholder"))
        nftNameLabel.text = item.nftName
        priceLabel.text = "\(item.price) dida"
        heartCountLabel.text = item.heartCount
        updateHeartImg()
        bind()
    }

    func bind() {
        heartContainerView.rx.tapGesture
            .subscribe(onNext: { [weak self] in
                print("My view was tapped")
                self?.isLiked.toggle()
                self?.updateHeartImg()
            })
            .disposed(by: disposeBag)
    }

    func updateHeartImg() {
        if self.isLiked {
            self.heartImageView.image = UIImage(named: "heart-fill")
        }else{
            
            self.heartImageView.image = UIImage(systemName : "heart")
        }
    }

}
