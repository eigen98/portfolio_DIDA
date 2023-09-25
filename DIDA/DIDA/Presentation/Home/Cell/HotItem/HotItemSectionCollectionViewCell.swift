//
//  HotItemSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit
import Kingfisher
import SkeletonView
import RxSwift

class HotItemSectionCollectionViewCell: UICollectionViewCell {
    
    struct Constants {
        static let cellWidth: CGFloat = 266
        static let cellHeight: CGFloat = 222
        static let sectionInsetTop: CGFloat = 11
        static let sectionInsetLeft: CGFloat = 16
        static let sectionInsetBottom: CGFloat = 11
        static let sectionInsetRight: CGFloat = 0
        static let spacing: CGFloat = 16
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var hotItems = [NFTEntity]()
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: - Configuration
extension HotItemSectionCollectionViewCell {
    
    func configureCollectionView() {
        hotItemCollectionView.delegate = self
        hotItemCollectionView.dataSource = self
        setupCollectionViewLayout()
        registerCollectionViewCell()
        bindCollectionViewScrolling()
        bindPageControllerValueChanged()
        hotItemCollectionView.reloadData()
    }
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
        layout.sectionInset = UIEdgeInsets(top: Constants.sectionInsetTop,
                                           left: Constants.sectionInsetLeft,
                                           bottom: Constants.sectionInsetBottom,
                                           right: Constants.sectionInsetRight)
        layout.scrollDirection = .horizontal
        hotItemCollectionView.collectionViewLayout = layout
    }
    
    private func registerCollectionViewCell() {
        hotItemCollectionView.register(UINib(nibName: "HotItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotItemCollectionViewCell")
    }
    
    private func bindCollectionViewScrolling() {
        hotItemCollectionView.rx.didScroll
            .subscribe(onNext: { [weak self] _ in
                self?.updatePageControllerCurrentPage()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindPageControllerValueChanged() {
        pageController.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                self?.scrollToCurrentPage()
            })
            .disposed(by: disposeBag)
    }
    
    private func updatePageControllerCurrentPage() {
        let proportionalOffset = (hotItemCollectionView.contentOffset.x + Constants.spacing) / (Constants.cellWidth + Constants.spacing)
        let currentPage = Int(round(proportionalOffset))
        pageController.currentPage = currentPage
    }
    
    private func scrollToCurrentPage() {
        let currentPage = pageController.currentPage
        let indexPath = IndexPath(item: currentPage, section: 0)
        hotItemCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HotItemSectionCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotItemCollectionViewCell", for: indexPath) as! HotItemCollectionViewCell
        let item = hotItems[indexPath.row]
        
        if item.cardId == -1 {
            cell.showSkeleton(usingColor: Colors.surface_2!)
            self.showSkeleton(usingColor: Colors.surface_2!)
        } else {
            cell.hideSkeleton()
            cell.configure(item: item)
        }
        return cell
    }
}
