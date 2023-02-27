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
    
    let viewModel = NoisyViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nftCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
        bindViewModel()
        
        viewModel.fetchNoisyNFT()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension NoisyTableViewCell {
    
    private func bindViewModel() {
        viewModel.noisyNFT
            .asDriver(onErrorJustReturn: [])
            .drive(nftCollectionView.rx.items(cellIdentifier: NFTCollectionViewCell.identifier, cellType: NFTCollectionViewCell.self)) { [weak self] item, element, cell in
                
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

