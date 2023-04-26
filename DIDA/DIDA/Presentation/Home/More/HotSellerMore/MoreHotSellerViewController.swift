//
//  MoreHotSellerViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/26.
//

import UIKit
import RxSwift
//HotSeller 더보기
class MoreHotSellerViewController: BaseViewController {

    var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel: MoreHotSellerViewModel = MoreHotSellerViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        // Do any additional setup after loading the view.
        bindViewModel()
        bindEvent()
    }
    
    override func bindViewModel() {
        viewModel.output.hotSellerData
            .bind(to: collectionView.rx.items(cellIdentifier: MoreHotSellerCollectionViewCell.reuseIdentifier, cellType: MoreHotSellerCollectionViewCell.self)) { index, item, cell in
//                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
    }




}
//MARK: UI
extension MoreHotSellerViewController{
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width - 32.0 , height: 226)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: MoreHotSellerCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MoreHotSellerCollectionViewCell.reuseIdentifier)
    }
}
