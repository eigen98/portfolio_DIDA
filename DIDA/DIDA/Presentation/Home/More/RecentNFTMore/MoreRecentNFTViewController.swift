//
//  MoreRecentNFTViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

//최신 NFT 더보기 ViewController
class MoreRecentNFTViewController: BaseViewController {

    private let disposeBag = DisposeBag()
    let viewModel: MoreRecentNFTViewModel = MoreRecentNFTViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleBar()
        initCollectionView()
        bindEvent()
        bindViewModel()
        viewModel.input.refreshTrigger.accept(())
        
    }
    
    override func bindViewModel() {
        viewModel.output.recentNFTData
            .bind(to: collectionView.rx.items(cellIdentifier: MoreRecentNFTCollectionViewCell.reuseIdentifier, cellType: MoreRecentNFTCollectionViewCell.self)) { index, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.showLoading
            .bind(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.viewModel.output.recentNFTData.onNext([NFTEntity.loading,
                                                                 NFTEntity.loading,
                                                                 NFTEntity.loading,
                                                                 NFTEntity.loading,
                                                                 NFTEntity.loading,
                                                                 NFTEntity.loading])
                } else {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

    }
    
    
    override func bindEvent() {
        collectionView.rx.modelSelected(NFTEntity.self)
            .subscribe(onNext: { item in
                
            })
            .disposed(by: disposeBag)
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refreshTrigger)
            .disposed(by: disposeBag)
    }
    
    private func setupTitleBar() {
        self.setupBackButton()
        customTitleBar.title = "최신 NFT"
    }
    
}
//MARK: UI
extension MoreRecentNFTViewController{
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width / 2 - 16 , height: 292)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        self.collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: MoreRecentNFTCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MoreRecentNFTCollectionViewCell.reuseIdentifier)
    }
}
