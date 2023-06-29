//
//  HotSellerSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit

class HotSellerSectionCollectionViewCell: UICollectionViewCell {
    
    
    var hotSellers = [UserEntity]()
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var createNFTButton: Buttons!
    
    
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
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layout()
        attribute()
        pageCollectionView.reloadData()
    }
    
    private func layout() {
        containerView.addSubview(pageCollectionView)
        
        pageCollectionView.snp.makeConstraints{
            $0.leading.equalTo(containerView.snp.leading).offset(16)
            $0.trailing.equalTo(containerView.snp.trailing).inset(16)
            $0.top.equalTo(containerView.snp.top).offset(87)
            $0.bottom.equalTo(containerView.snp.bottom).inset(42)
        }
        
        
    }
    
    private func attribute(){
        self.createNFTButton.shape = .round
        self.createNFTButton.style = .primary
        self.createNFTButton.buttonHeight = .h56
        
        if hotSellers.count == 0{
            emptyContainerView.isHidden = false
        }else{
            emptyContainerView.isHidden = true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension HotSellerSectionCollectionViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotSellers.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SellerCollectionViewCell
        
        let item = hotSellers[indexPath.row]
        cell.configure(seller: item)
        cell.configureMoreButton(seller: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if indexPath.row == hotSellers.count{
            var nextResponder = self.next
            while nextResponder != nil {
                if let viewController = nextResponder as? UIViewController {
                    if let navController = viewController.navigationController {
                        let nextVC = MoreHotSellerViewController()
                        navController.pushViewController(nextVC, animated: true)
                        break
                    }
                }
                nextResponder = nextResponder?.next
            }
        }
        
    }
}




