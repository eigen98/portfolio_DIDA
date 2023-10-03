//
//  NFTCommunityCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import UIKit

class NFTCommunityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postButton: Buttons!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideSkeleton()
        setupButton()
    }
    
    func configure(with data: CommunityData?) {
        guard let data = data else {
            showSkeleton()
            return
        }
        hideSkeleton()
    }
    
    private func setupButton() {
        postButton.shape = .round
        postButton.backgroundColor = .white
        postButton.tintColor = .black
        let font = UIFont(name: "Pretendard-Bold", size: 16)
        postButton.titleLabel?.font = font
    }
    
}
