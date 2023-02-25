//
//  HotSellerTableViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/02/19.
//

import UIKit
//홈뷰의 TabbarCell 컨테이너 Cell입니다.
class HotSellerTableViewCell: UITableViewCell, MainCustomTabbarDelegate {
    

    //MARK: Outltes
        var pageCollectionView: UICollectionView = {
            let collectionViewLayout = UICollectionViewFlowLayout()
            collectionViewLayout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: collectionViewLayout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .black
            return collectionView
        }()
    
    var customMenuBar = MainCustomTabbar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        


        setupCustomTabBar()
        
        setupPageCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: Setup view
        func setupCustomTabBar(){
            self.contentView.addSubview(customMenuBar)
            customMenuBar.backgroundColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1)
            customMenuBar.delegate = self
            customMenuBar.translatesAutoresizingMaskIntoConstraints = false
            customMenuBar.indicatorViewWidthConstraint.constant = self.contentView.frame.width / 4
            customMenuBar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            customMenuBar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            customMenuBar.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            customMenuBar.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }
        
        func customMenuBar(scrollTo index: Int) {
            let indexPath = IndexPath(row: index, section: 0)
            self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        func setupPageCollectionView(){
            pageCollectionView.delegate = self
            pageCollectionView.dataSource = self
            pageCollectionView.backgroundColor = .black
            pageCollectionView.showsHorizontalScrollIndicator = false
            pageCollectionView.isPagingEnabled = true
            pageCollectionView.register(UINib(nibName: "MainTabbarPageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainTabbarPageCollectionViewCell")
            pageCollectionView.isScrollEnabled = false
            self.contentView.addSubview(pageCollectionView)
            
            
            pageCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            pageCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            pageCollectionView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
            pageCollectionView.topAnchor.constraint(equalTo: self.customMenuBar.bottomAnchor).isActive = true
        }
    
    
    
}

extension HotSellerTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTabbarPageCollectionViewCell", for: indexPath) as! MainTabbarPageCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customMenuBar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.contentView.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customMenuBar.customTabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension HotSellerTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
