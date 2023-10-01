//
//  ActivitySectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/09.
//

import UIKit
import RxSwift

class ActivitySectionCollectionViewCell: UICollectionViewCell {

    //첫번째 유저 프로필
    var disposeBag = DisposeBag()
    private let viewModel = ActivitySectionViewModel()
    let primaryStyleString = "primary"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var emptyContainerView: UIView!
    
    @IBOutlet weak var createNFTButton: Buttons!
    
    
    @IBOutlet weak var firstItemContainerView: UIView!
    
    @IBOutlet weak var firstItemImageView: UIImageView!
    
    @IBOutlet weak var firstItemNameLabel: UILabel!
    
    @IBOutlet weak var firstItemCountLabel: UILabel!
    
    
    @IBOutlet weak var firstFollowButton: Buttons!
    
    //두번째 유저 프로필
    
    @IBOutlet weak var secondItemContainerView: UIView!
    
    @IBOutlet weak var secondItemImageView: UIImageView!
    
    @IBOutlet weak var secondItemNameLabel: UILabel!
    
    @IBOutlet weak var secondItemCountLabel: UILabel!
    
    @IBOutlet weak var secondFollowButton: Buttons!
    
    @IBOutlet weak var moreButton: UIButton!
    
    
    //세번째 유저 프로필
    
    
    @IBOutlet weak var thirdItemContainerView: UIView!
    
    @IBOutlet weak var thirdItemImageView: UIImageView!
    
    @IBOutlet weak var thirdItemNameLabel: UILabel!
    
    @IBOutlet weak var thirdItemCountLabel: UILabel!
    
    @IBOutlet weak var thirdFollowButton: Buttons!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    func configure(items: [UserEntity]) {
        disposeBag = DisposeBag() // disposeBag을 초기화합니다.
        clearViews()
        setupSkeletonView(with: items)
        setupEmptyView(with: items)
        bindViewModel() // bindViewModel을 여기서 호출하여 버튼에 대한 구독을 설정합니다.
        viewModel.configure(items: items)
    }
    
    private func setupSkeletonView(with items: [UserEntity]) {
        if items.first == UserEntity.loading {
            showSkeleton(usingColor: Colors.surface_2!)
        } else {
            hideSkeleton()
        }
    }
    
    private func setupEmptyView(with items: [UserEntity]) {
        createNFTButton.shape = .round
        createNFTButton.style = .primary
        createNFTButton.buttonHeight = .h56
        emptyContainerView.isHidden = !items.isEmpty
    }
    
    private func clearViews() {
        let containerViews = [firstItemContainerView, secondItemContainerView, thirdItemContainerView]
        let imageViews = [firstItemImageView, secondItemImageView, thirdItemImageView]
        let nameLabels = [firstItemNameLabel, secondItemNameLabel, thirdItemNameLabel]
        let countLabels = [firstItemCountLabel, secondItemCountLabel, thirdItemCountLabel]
        
        containerViews.forEach { $0?.isHidden = true }
        imageViews.forEach { $0?.image = nil }
        nameLabels.forEach { $0?.text = nil }
        countLabels.forEach { $0?.text = nil }
    }

    private func bindViewModel() {
        bindMoreButton()
        bindFollowButtons()
        bindViewModelOutputs()
    }
    
    private func bindMoreButton() {
        moreButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                self?.navigateToMoreActivityViewController()
            })
            .disposed(by: disposeBag)
    }
    
    private func navigateToMoreActivityViewController() {
        guard let viewController = parentViewController,
              let navController = viewController.navigationController else { return }
        let nextVC = MoreActivityViewController()
        navController.pushViewController(nextVC, animated: true)
    }
    
    private func bindFollowButtons() {
        let followButtons = [firstFollowButton, secondFollowButton, thirdFollowButton]
        for (index, followButton) in followButtons.enumerated() {
            followButton?.rx.tap
                .map { index }
                .bind(to: viewModel.input.followButtonTapped)
                .disposed(by: disposeBag)
        }
    }
    
    private func bindViewModelOutputs() {
        viewModel.output.followStatusChanged
            .subscribe(onNext: { [weak self] (isFollowing, index) in
                self?.configureButtons(idx: index, bool: isFollowing)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.items
            .subscribe(onNext: { [weak self] items in
                self?.configureViews(with: items)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureViews(with items: [UserEntity]) {
        for (index, item) in items.enumerated() {
            configureView(at: index, with: item)
        }
    }
    
    private func configureView(at index: Int, with item: UserEntity) {
        let containerViews = [firstItemContainerView, secondItemContainerView, thirdItemContainerView]
        let imageViews = [firstItemImageView, secondItemImageView, thirdItemImageView]
        let nameLabels = [firstItemNameLabel, secondItemNameLabel, thirdItemNameLabel]
        let countLabels = [firstItemCountLabel, secondItemCountLabel, thirdItemCountLabel]
        let followButtons = [firstFollowButton, secondFollowButton, thirdFollowButton]
        
        containerViews[index]?.isHidden = false
        configureView(imageView: imageViews[index], nameLabel: nameLabels[index], countLabel: countLabels[index], with: item)
        configureButtons(idx: index, bool: item.isFollowing)
    }

    
    private func configureView(imageView: UIImageView?, nameLabel: UILabel?, countLabel: UILabel?, with item: UserEntity) {
        if let url = URL(string: item.profileImage ?? "") {
            imageView?.kf.setImage(with: url)
        }
        nameLabel?.text = item.nickname
        countLabel?.text = "\(item.cardCnt) 작품"
    }
    
    private func configureButtons(idx: Int, bool: Bool) {
        let buttons = [firstFollowButton, secondFollowButton, thirdFollowButton]
        buttons[idx]?.style = bool ? .primary : .dialog
        buttons[idx]?.shape = .circle
        let text = bool ? "팔로잉" : "팔로우"
        buttons[idx]?.setTitle(text, for: .normal)
        let color = bool ? UIColor.black : UIColor.white
        buttons[idx]?.customTitleColor = .init(normal: color, disabled: color, selected: color, hightlight: color)
    }
}
