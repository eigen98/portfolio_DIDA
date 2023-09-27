//
//  MoreActivityViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import UIKit
import RxSwift
import RxCocoa
class MoreActivityViewController: BaseViewController {

    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel: MoreActivityViewModel = MoreActivityViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupTitleBar()
        initCollectionView()
        bindEvent()
        bindViewModel()
        viewModel.input.refreshTrigger.accept(())
    }
    
    override func bindEvent() {
        collectionView.rx.modelSelected(MoreActivityEntity.self)
            .subscribe(onNext: { item in
               
            })
            .disposed(by: disposeBag)
        
        collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refreshTrigger)
            .disposed(by: disposeBag)
    }
    
    private func setupTitleBar() {
           self.setupBackButton()
           customTitleBar.title = "활발한 활동"
       }
       
       override func bindViewModel() {
           viewModel.output.activityData
               .bind(to: collectionView.rx.items(cellIdentifier: MoreActivityCollectionViewCell.reuseIdentifier, cellType: MoreActivityCollectionViewCell.self)) { index, item, cell in
                   cell.configure(item: item)
               }
               .disposed(by: disposeBag)
           
           viewModel.showLoading
               .bind(onNext: { [weak self] isLoading in
                   if isLoading {
                       self?.showLoadingBlocker()
                       self?.viewModel.output.activityData.onNext([.loading, .loading, .loading])
                   } else {
                       self?.hideLoadingBlocker()
                       self?.collectionView.refreshControl?.endRefreshing()
                   }
               })
               .disposed(by: disposeBag)
       }
   }

// MARK: - UI
extension MoreActivityViewController{
    func initCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width - 32.0, height: 230)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: MoreActivityCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MoreActivityCollectionViewCell.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
    }
    
    
}
