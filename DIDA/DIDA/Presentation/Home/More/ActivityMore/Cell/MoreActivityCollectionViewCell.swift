//
//  CollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/04/25.
//

import UIKit
import RxSwift
class MoreActivityCollectionViewCell: UICollectionViewCell {

    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var articleCountLabel: UILabel!
    
    @IBOutlet weak var followButton: Buttons!
    
    @IBOutlet weak var imageGridContainerView: UIView!
    
    private let imageGridView = ImageGridView()
    var isFollowed = false
    
     override func awakeFromNib() {
         super.awakeFromNib()
         setupImageGridView()
         setupButton()
     }
     
     override func prepareForReuse() {
         super.prepareForReuse()
         resetCell()
     }
     
     private func resetCell() {
         isFollowed = false
         profileImageView.kf.cancelDownloadTask()
         self.hideSkeleton()
         disposeBag = DisposeBag()
     }
     
     func configure(item: MoreActivityEntity) {
         if item == MoreActivityEntity.loading{
             self.showSkeleton()
             return
         }
         bindFollowButton()
         loadImage(from: item.profileUrl)
         configureLabels(with: item)
         isFollowed = item.followed
         updateFollowButtonStyle()
         configureImageGridView(with: item.cardUrls)
     }
     
     private func configureLabels(with item: MoreActivityEntity) {
         userNameLabel.text = item.name
         articleCountLabel.text = "\(item.cardCnt) 작품"
     }
     
     private func loadImage(from urlString: String?) {
         guard let urlString = urlString, let url = URL(string: urlString) else {
            
             return
         }
         profileImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "placeholder"))
     }
     
     private func configureImageGridView(with urls: [String]) {
         let imageUrls = urls.compactMap { URL(string: $0) }
         imageGridView.configure(with: imageUrls)
     }
     
     private func setupButton() {
         
     }
     
     private func updateFollowButtonStyle() {
         if isFollowed {
             
             followButton.style = .dialog
             followButton.setTitle("팔로우", for: .normal)
             followButton.customTitleColor = .init(normal: .white, disabled: .white, selected: .white, hightlight: .white)
         } else {
             followButton.style = .primary
             followButton.setTitle("팔로잉", for: .normal)
             followButton.customTitleColor = .init(normal: .black, disabled: .white, selected: .white, hightlight: .white)
         }
     }
     
     private func bindFollowButton() {
         followButton.rx.tap
             .bind { [weak self] in
                 self?.isFollowed.toggle()
                 self?.updateFollowButtonStyle()
             }
             .disposed(by: disposeBag)
     }
     
     private func setupImageGridView() {
         imageGridContainerView.addSubview(imageGridView)
         imageGridView.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             imageGridView.topAnchor.constraint(equalTo: imageGridContainerView.topAnchor),
             imageGridView.bottomAnchor.constraint(equalTo: imageGridContainerView.bottomAnchor),
             imageGridView.leadingAnchor.constraint(equalTo: imageGridContainerView.leadingAnchor),
             imageGridView.trailingAnchor.constraint(equalTo: imageGridContainerView.trailingAnchor)
         ])
     }
 }
