//
//  RecentNFTSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/09.
//

import UIKit
import Kingfisher
import RxSwift


class RecentNFTSectionCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let heartFillImageName = "heart-fill"
        static let heartUnfillImageName = "heart-unfill"
        static let defaultDecimalString = "0.00"
        static let thousandSuffix = "K"
        static let millionSuffix = "M"
        static let decimalMaximumFractionDigits = 2
    }
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstItemsContainerView: UIView!
    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var firstItemImageView: UIImageView!
    @IBOutlet weak var firstUserNameLabel: UILabel!
    @IBOutlet weak var firstNFTNameLabel: UILabel!
    @IBOutlet weak var firstProfileImageView: UIImageView!
    @IBOutlet weak var firstPriceLabel: UILabel!
    @IBOutlet weak var firstLikeButton: UIButton!
    @IBOutlet weak var secondItemImageView: UIImageView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var secondUserNameLabel: UILabel!
    @IBOutlet weak var secondProfileImageView: UIImageView!
    @IBOutlet weak var secondPriceLabel: UILabel!
    @IBOutlet weak var secondNFTNameLabel: UILabel!
    @IBOutlet weak var secondLikeButton: UIButton!
    @IBOutlet weak var secondItemsContainerView: UIView!
    @IBOutlet weak var thirdItemImageView: UIImageView!
    @IBOutlet weak var thirdContainerView: UIView!
    @IBOutlet weak var thirdUserNameLabel: UILabel!
    @IBOutlet weak var thirdNFTNameLabel: UILabel!
    @IBOutlet weak var thirdProfileImageView: UIImageView!
    @IBOutlet weak var thirdPriceLabel: UILabel!
    @IBOutlet weak var thirdLikeButton: UIButton!
    @IBOutlet weak var fourthItemImageView: UIImageView!
    @IBOutlet weak var fourthContainerView: UIView!
    @IBOutlet weak var fourthUserNameLabel: UILabel!
    @IBOutlet weak var fourthNFTNameLabel: UILabel!
    @IBOutlet weak var fourthProfileImageView: UIImageView!
    @IBOutlet weak var fourthPriceLabel: UILabel!
    @IBOutlet weak var fourthLikeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Configuration
    func configure(items: [NFTEntity]) {
        bind()
        
        let containerViews = [firstContainerView, secondContainerView, thirdContainerView, fourthContainerView]
        let itemViews: [(UIImageView?, UILabel?, UILabel?, UILabel?, UIButton?)] = [
            (firstItemImageView, firstUserNameLabel, firstNFTNameLabel, firstPriceLabel, firstLikeButton),
            (secondItemImageView, secondUserNameLabel, secondNFTNameLabel, secondPriceLabel, secondLikeButton),
            (thirdItemImageView, thirdUserNameLabel, thirdNFTNameLabel, thirdPriceLabel, thirdLikeButton),
            (fourthItemImageView, fourthUserNameLabel, fourthNFTNameLabel, fourthPriceLabel, fourthLikeButton)
        ]
        
        for (index, containerView) in containerViews.enumerated() {
            containerView?.isHidden = index >= items.count
        }
        
        for (index, item) in items.enumerated() {
            if index >= itemViews.count { break }
            if let url = URL(string: item.nftImg) {
                itemViews[index].0?.kf.setImage(with: url)
            }
            itemViews[index].1?.text = item.nickname
            itemViews[index].2?.text = item.nftName
            itemViews[index].3?.text = "\(roundedStringToTwoDecimalPlaces(value: (item.price)))"
            let imageName = item.liked ? Constants.heartFillImageName : Constants.heartUnfillImageName
            itemViews[index].4?.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    // MARK: - Binding
    private func bind() {
        moreButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let viewController = self?.parentViewController,
                      let navController = viewController.navigationController else { return }
                
                let nextVC = MoreRecentNFTViewController()
                navController.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        let likeButtons = [firstLikeButton, secondLikeButton, thirdLikeButton, fourthLikeButton]

        for likeButton in likeButtons {
            likeButton?.rx.tap
                .subscribe(onNext: { [weak self, weak likeButton] in
                    guard let self = self, let likeButton = likeButton else { return }
                    let isLiked = likeButton.isSelected
                    likeButton.isSelected = !isLiked
                    let imageName = !isLiked ? Constants.heartFillImageName : Constants.heartUnfillImageName
                    likeButton.setImage(UIImage(named: imageName), for: .normal)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Helper Methods
    private func roundedStringToTwoDecimalPlaces(value: String) -> String {
        if value.isEmpty { return Constants.defaultDecimalString }
        
        if let doubleValue = Double(value) {
            let absValue = abs(doubleValue)
            let sign = doubleValue < 0 ? "-" : ""
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = Constants.decimalMaximumFractionDigits
            
            let (divisor, suffix): (Double, String) = {
                if absValue < 1_000 { return (1, "") }
                if absValue < 1_000_000 { return (1_000, Constants.thousandSuffix) }
                return (1_000_000, Constants.millionSuffix)
            }()
            
            let formattedValue = formatter.string(from: NSNumber(value: absValue / divisor)) ?? ""
            return "\(sign)\(formattedValue)\(suffix) dida"
        } else {
            return value
        }
    }
}
