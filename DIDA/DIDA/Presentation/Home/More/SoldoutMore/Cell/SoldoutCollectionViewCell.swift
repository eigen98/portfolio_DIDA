//
//  SoldoutCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/26.
//

import UIKit
import RxSwift

class SoldoutCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nftNameLabel: UILabel!

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        self.hideSkeleton()
        disposeBag = DisposeBag()
    }
    
    func configure(item: NFTEntity) {
        if item == NFTEntity.loading{
            self.showSkeleton()
            return
        }
        nftNameLabel.text = item.nftName
        userNameLabel.text = item.nickname
        priceLabel.text = roundedStringToTwoDecimalPlaces(value: item.price)
        
        imageView.kf.setImage(with: URL(string: item.nftImg), options: [.scaleFactor(CGFloat(1.0))])
    }
    
    func roundedStringToTwoDecimalPlaces(value: String) -> String {
        if value.isEmpty { return "00.00" }
        
        if let doubleValue = Double(value) {
            let roundedValue = round(doubleValue * 100) / 100
            return String(format: "%.2f", roundedValue)
        }
        
        return "00.00"
    }
}
