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

        
        initCollectionView()
        bindEvent()
        bindViewModel()
    }
    
    override func bindViewModel() {
        viewModel.output.activityData
            .bind(to: collectionView.rx.items(cellIdentifier: MoreActivityCollectionViewCell.reuseIdentifier, cellType: MoreActivityCollectionViewCell.self)) { index, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
    }

}
//MARK: UI
extension MoreActivityViewController{
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width - 32.0 , height: 230)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: MoreActivityCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MoreActivityCollectionViewCell.reuseIdentifier)
    }
}
