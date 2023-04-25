//
//  HotSellerSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit

class HotSellerSectionCollectionViewCell: UICollectionViewCell {
    
    
    var hotSellers = [HotSellerEntity]()
    @IBOutlet weak var containerView: UIView!
    
    private let cellIdentifier = "SellerCollectionViewCell"
    
    lazy var pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 126, height: 174)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPageCollectionView()
    }
    
    private func setupPageCollectionView() {
        containerView.addSubview(pageCollectionView)
        
        NSLayoutConstraint.activate([
            pageCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pageCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pageCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pageCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
        
        pageCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension HotSellerSectionCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1//hotSellers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SellerCollectionViewCell
//        let item = hotSellers[indexPath.row]
//        cell.configure(seller: item)
        return cell
    }
}




