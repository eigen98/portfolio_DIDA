//
//  NFTCollectionViewCell.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/26.
//

import UIKit

final class NFTCollectionViewCell: UICollectionViewCell {

    static let identifier = "NFTCollectionViewCell"
    
    @IBOutlet weak var nftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

}

extension NFTCollectionViewCell {
    private func configure() {
        nftImageView.layer.cornerRadius = 10
        nftImageView.clipsToBounds = true
        nftImageView.backgroundColor = Colors.brand_lemon_100 //임시
    }
}
