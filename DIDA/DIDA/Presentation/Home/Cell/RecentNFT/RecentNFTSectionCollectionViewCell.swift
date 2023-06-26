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

    var items = [NFTEntity]()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    //상단 컨테이너 뷰
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
    
    
    //하단 컨테이너 뷰
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
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(items : [NFTEntity]){
        
        bind()
        self.items = items
        
        // 첫 번째 아이템이 싱글톤 로딩 객체인지 확인
        if items.first == NFTEntity.loading {
//            스켈레톤 뷰를 보여줍니다.
            self.showSkeleton(usingColor: Colors.surface_2!)
        } else {
//            스켈레톤 뷰를 숨깁니다.
            self.hideSkeleton()
        }
        
        let itemViews: [(UIImageView?, UILabel?, UILabel?, UILabel?, UIButton?)] = [
                (firstItemImageView, firstUserNameLabel, firstNFTNameLabel, firstPriceLabel, firstLikeButton),
                (secondItemImageView, secondUserNameLabel, secondNFTNameLabel, secondPriceLabel, secondLikeButton),
                (thirdItemImageView, thirdUserNameLabel, thirdNFTNameLabel, thirdPriceLabel, thirdLikeButton),
                (fourthItemImageView, fourthUserNameLabel, fourthNFTNameLabel, fourthPriceLabel, fourthLikeButton)
            ]
            // 아이템 이미지 로드
            for (index, item) in items.enumerated() {
                if let url = URL(string: item.nftImg) {
                    itemViews[index].0?.kf.setImage(with: url)
                }
                // 아이템의 텍스트 필드 설정
                itemViews[index].1?.text = item.nickname
                itemViews[index].2?.text = item.nftName
                itemViews[index].3?.text = "\(roundedStringToTwoDecimalPlaces(value: (item.price))) dida"
                //좋아요 여부에 따라 설정
                let imageName = item.liked ? "heart-fill" : "heart-unfill"
                itemViews[index].4?.setImage(UIImage(named: imageName), for: .normal)
            }
        
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    //스켈레톤 로딩뷰 보여주기
    func configureLoadingView(){
        [titleLabel,
         firstContainerView,
         secondContainerView,
         thirdContainerView,
         fourthContainerView,
         moreButton]
            .forEach{
                $0.startSkeletonAnimation(cornerRadius: 8)
            }
    }
    
    func removeLottieAnimationView(){
        [titleLabel,
         firstContainerView,
         secondContainerView,
         thirdContainerView,
         fourthContainerView,
         moreButton]
            .forEach{
                $0.stopSkeletonAnimation()
            }
        moreButton.backgroundColor = .init(hex: "#33333333")
    }
    

}

extension RecentNFTSectionCollectionViewCell{
    func bind(){
        moreButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                print("tap()")
                var nextResponder = self.next
                while nextResponder != nil {
                    if let viewController = nextResponder as? UIViewController {
                        print("viewController : \(viewController)")
                        if let navController = viewController.navigationController {
                            print("navi : \(navController)")
                            let nextVC = MoreRecentNFTViewController()
                            navController.pushViewController(nextVC, animated: true)
                            break
                        }
                    }
                    nextResponder = nextResponder?.next
                }
            })
            .disposed(by: disposeBag)
        
        let likeButtons = [firstLikeButton, secondLikeButton, thirdLikeButton, fourthLikeButton]

        for (index, likeButton) in likeButtons.enumerated() {
            likeButton?.rx.tap
                .map { [weak self] in
                    let isLiked = !(self?.items[index].liked ?? false)
                    self?.items[index].liked = isLiked
                    return isLiked
                }
                .do(onNext: { isLiked in
                    let imageName = isLiked ? "heart-fill" : "heart-unfill"
                    likeButton?.setImage(UIImage(named: imageName), for: .normal)
                })
                .subscribe()
                .disposed(by: disposeBag)
        }
        
    }
    
    /*
     String 값을 소수점 둘째 자리 수까지 반올림하는 함수.
     */
    func roundedStringToTwoDecimalPlaces(value: String) -> String {
        if value == "" { return "0.00" }
            if let doubleValue = Double(value) {
                var resultValue = ""
                let absValue = abs(doubleValue)
                let sign = doubleValue < 0 ? "-" : ""
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 2
                if absValue < 1000 {
                    resultValue = formatter.string(from: NSNumber(value: absValue)) ?? ""
                } else if absValue < 1000000 {
                    resultValue = formatter.string(from: NSNumber(value: absValue / 1000)) ?? ""
                    resultValue += "K"
                } else {
                    resultValue = formatter.string(from: NSNumber(value: absValue / 1000000)) ?? ""
                    resultValue += "M"
                }
                return "\(sign)\(resultValue)"
            }
            return "0.00"
    }
}
