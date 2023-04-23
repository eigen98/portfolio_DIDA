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

    var items = [UserNftEntity]()
    //상단 컨테이너 뷰
    @IBOutlet weak var firstItemsContainerView: UIView!
    
    @IBOutlet weak var firstItemImageView: UIImageView!
    
    @IBOutlet weak var secondItemImageView: UIImageView!
    //하단 컨테이너 뷰
    @IBOutlet weak var secondItemsContainerView: UIView!
    
    @IBOutlet weak var thirdItemImageView: UIImageView!
    
    @IBOutlet weak var fourthItemImageView: UIImageView!
    
    
    @IBOutlet weak var moreButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(items : [UserNftEntity]){
        
        bind()
        
        let numberOfItems = items.count
        switch numberOfItems {
        case 4 :
            print("아이템 4개")
            let firstItem = items[0]
            let secondItem = items[1]
            let thirdItem = items[2]
            let fourthItem = items[3]
            
            if let url = URL(string: firstItem.imgUrl){
                firstItemImageView.kf.setImage(with: url)
            }
            
            if let url = URL(string: secondItem.imgUrl){
                secondItemImageView.kf.setImage(with: url)
            }
            
            if let url = URL(string: thirdItem.imgUrl){
                thirdItemImageView.kf.setImage(with: url)
            }
            
            if let url = URL(string: fourthItem.imgUrl){
                fourthItemImageView.kf.setImage(with: url)
            }
           
            
            break
        case 3:
            print("아이템 3개")
            break
        case 2:
            print("아이템 2개")
            break
        case 1:
            print("아이템 1개")
            let firstItem = items[0]
            
            break
        default:
            break
        }
        
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
    }
}
