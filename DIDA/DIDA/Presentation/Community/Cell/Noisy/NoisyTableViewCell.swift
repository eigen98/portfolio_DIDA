//
//  NoisyTableViewCell.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/26.
//

import UIKit
import RxSwift
import RxCocoa

final class NoisyTableViewCell: UITableViewCell {

    static let identifier = "NoisyTableViewCell"
    var dummy = BehaviorRelay<[String]>(value: ["","","","","","","","","","","","","",""])
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nftCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
        bind()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension NoisyTableViewCell {
    
    //뷰모델 만든뒤에 바꿔야할듯. 일단 임시로 따로 만듦.
    private func bind() {
        dummy
            .asDriver(onErrorJustReturn: [])
            .drive(nftCollectionView.rx.items(cellIdentifier: NFTCollectionViewCell.identifier, cellType: NFTCollectionViewCell.self)) { [weak self] item, element, cell in
                //임시
                
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        infoLabel.font = Fonts.regular_14
        
        nftCollectionView.register(UINib(nibName: NFTCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: NFTCollectionViewCell.identifier)
        
        createLayout()
    }
    
    private func createLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.itemSize = CGSize(width: 114, height: 114)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        nftCollectionView.collectionViewLayout = layout
    }
}

