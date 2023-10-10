//
//  OwnershipNFTViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/30.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class OwnershipNFTViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    let viewModel: OwnershipNFTViewModel = OwnershipNFTViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
        setupBackButton()
    }
    
    override func bindViewModel() {
        let input = OwnershipNFTViewModel.Input(
            refreshTrigger: .just(())
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SectionModel<String, Owner>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<String, Owner>>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource.sectionModels[indexPath.section].model {
                case "현재 소유자":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentOwnerCollectionViewCell.reuseIdentifier, for: indexPath) as! CurrentOwnerCollectionViewCell
                    cell.configure(with: item)
                    return cell
                case "이전 소유 내역":
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviousOwnerCollectionViewCell.reuseIdentifier, for: indexPath) as! PreviousOwnerCollectionViewCell
                    cell.configure(with: item)
                    return cell
                default:
                    fatalError("Unexpected section title")
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OwnershipSectionHeader.reuseIdentifier, for: indexPath) as! OwnershipSectionHeader
                header.titleLabel.text = dataSource.sectionModels[indexPath.section].model
                return header
            }
        )
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: CurrentOwnerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CurrentOwnerCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: PreviousOwnerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PreviousOwnerCollectionViewCell.reuseIdentifier)
        
        collectionView.register(OwnershipSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: OwnershipSectionHeader.reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 40)
        self.collectionView.collectionViewLayout = layout
    }
}

struct Owner {
    var date: String
    var userName: String
    var price: String
}
