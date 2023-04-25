//
//  HotItemSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit
import Kingfisher

class HotItemSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var hotItemCollectionView: UICollectionView!
    
    var hotItems = [HotItemEntity]()
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    
}

extension HotItemSectionCollectionViewCell {
    private func configureCollectionView() {
        hotItemCollectionView.delegate = self
        hotItemCollectionView.dataSource = self
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: 266, height: 222)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 32, right: 0)
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
        cell.configure(item: item)
      
        return cell
    }
    
    
}


// UICollectionViewCell 최대한 왼쪽정렬시켜주는 flowLayout
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      if layoutAttribute.representedElementCategory == .cell {
        if layoutAttribute.frame.origin.y >= maxY {
          leftMargin = sectionInset.left
        }
        layoutAttribute.frame.origin.x = leftMargin
        leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
        maxY = max(layoutAttribute.frame.maxY, maxY)
      }
    }
    return attributes
  }
}
