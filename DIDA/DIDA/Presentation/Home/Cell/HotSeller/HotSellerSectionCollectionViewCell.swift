//
//  HotSellerSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit

class HotSellerSectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    
    //MARK: Outltes
    var pageCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 100), collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        // 왼쪽 정렬
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 126, height: 174)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
             

        return collectionView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupPageCollectionView()
    }
    
    //MARK: Setup view
    func setupPageCollectionView(){
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        pageCollectionView.backgroundColor = .black
        pageCollectionView.showsHorizontalScrollIndicator = false
       
        pageCollectionView.register(UINib(nibName: "SellerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SellerCollectionViewCell")
        pageCollectionView.isScrollEnabled = true
       
        self.containerView.addSubview(pageCollectionView)
        pageCollectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        pageCollectionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        pageCollectionView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        pageCollectionView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -40).isActive = true
       
        pageCollectionView.reloadData()
    }
}

    
    
   







//MARK:- UICollectionViewDelegateFlowLayout
extension HotSellerSectionCollectionViewCell: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellerCollectionViewCell", for: indexPath) as! SellerCollectionViewCell
        return cell
    }
   

    
    
  
}
