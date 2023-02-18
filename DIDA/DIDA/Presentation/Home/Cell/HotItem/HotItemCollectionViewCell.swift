//
//  HotItemCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/18.
//

import UIKit

//HOT Item 리스트 컬렉션뷰 셀
class HotItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nftNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
