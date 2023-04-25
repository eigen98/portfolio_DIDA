//
//  RecentNFTSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/09.
//

import UIKit
import Kingfisher


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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(items : [UserNftEntity]){
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
    
    
    
    

}
