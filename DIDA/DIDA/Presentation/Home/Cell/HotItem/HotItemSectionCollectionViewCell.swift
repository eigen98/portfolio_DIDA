//
//  HotItemSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit
import Kingfisher
import SkeletonView

class HotItemSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    
    var hotItems = [NFTEntity]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

    
}

extension HotItemSectionCollectionViewCell {
    
    func configureCollectionView() {
        hotItemCollectionView.delegate = self
        hotItemCollectionView.dataSource = self
       
        //hotItemCollectionView.isSkeletonable = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 266, height: 222)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
        layout.scrollDirection = .horizontal
       
        hotItemCollectionView.collectionViewLayout = layout
        
        hotItemCollectionView.register(UINib(nibName: "HotItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotItemCollectionViewCell")
        
        hotItemCollectionView.reloadData()
    }

}

extension HotItemSectionCollectionViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotItemCollectionViewCell", for: indexPath) as! HotItemCollectionViewCell
        
        let item = self.hotItems[indexPath.row]
        
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
