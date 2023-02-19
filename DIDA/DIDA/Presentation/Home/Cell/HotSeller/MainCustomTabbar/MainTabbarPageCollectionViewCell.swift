//
//  MainTabbarPageCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/19.
//

import UIKit

class MainTabbarPageCollectionViewCell: UICollectionViewCell {

    
    var sellerCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: collectionViewLayout)
        collectionViewLayout.minimumInteritemSpacing = 14
        collectionViewLayout.itemSize = CGSize(width: 126, height: 174)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectioView()
        setupCustomTabBar()
    }

    //MARK: Setup Views
    func setupCollectioView(){
        sellerCollectionView.delegate = self
        sellerCollectionView.dataSource = self
        sellerCollectionView.showsHorizontalScrollIndicator = false
        sellerCollectionView.register(UINib(nibName: "SellerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SellerCollectionViewCell")
        sellerCollectionView.isScrollEnabled = true
        
        let indexPath = IndexPath(item: 0, section: 0)
        sellerCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    func setupCustomTabBar(){
        setupCollectioView()
        self.addSubview(sellerCollectionView)
        sellerCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sellerCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        sellerCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        sellerCollectionView.heightAnchor.constraint(equalToConstant: 174).isActive = true
        
    }
    
    
}
//MARK:- UICollectionViewDelegate, DataSource
extension MainTabbarPageCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerCollectionViewCell", for: indexPath) as! SellerCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

}
