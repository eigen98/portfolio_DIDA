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
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    
    
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
        bind()
        clearViews()
        if items.first?.userId == -1{
            configureLoadingView()
        }else{
            removeLottieAnimationView()
        }
        
        for (index, item) in items.enumerated() {
            if index == 0 {
                firstItemContainerView.isHidden = false
                configureView(firstItemImageView, firstItemNameLabel, firstItemCountLabel, item)
                //viewModel.input.followButtonTapped.accept((items[0].followed, 0))
            } else if index == 1 {
                secondItemContainerView.isHidden = false
                configureView(secondItemImageView, secondItemNameLabel, secondItemCountLabel, item)
                //viewModel.input.followButtonTapped.accept((items[1].followed, 1))
            } else if index == 2 {
                thirdItemContainerView.isHidden = false
                configureView(thirdItemImageView, thirdItemNameLabel, thirdItemCountLabel, item)
                //viewModel.input.followButtonTapped.accept((items[1].followed, 0))
            }
        }
        
        
        
    }
    
    private func configureView(_ imageView: UIImageView, _ nameLabel: UILabel, _ countLabel: UILabel, _ item: UserEntity) {
        if let url = URL(string: item.profileImage ?? "") {
               imageView.kf.setImage(with: url)
           }
        nameLabel.text = item.nickname
        countLabel.text = "\(item.cardCnt) 작품"
    }
    
    private func clearViews() {
        firstItemContainerView.isHidden = true
        secondItemContainerView.isHidden = true
        thirdItemContainerView.isHidden = true
        
        firstItemImageView.image = nil
        firstItemNameLabel.text = nil
        firstItemCountLabel.text = nil
        
        secondItemImageView.image = nil
        secondItemNameLabel.text = nil
        secondItemCountLabel.text = nil
        
        thirdItemImageView.image = nil
        thirdItemNameLabel.text = nil
        thirdItemCountLabel.text = nil
    }
    
    
    func configureButtons(idx: Int, bool : Bool){
        let buttons = [firstFollowButton, secondFollowButton, thirdFollowButton]
        buttons[idx]?.style = bool ? .dialog : .primary
        buttons[idx]?.shape = .circle
        
        let text = bool ? "팔로우" : "팔로잉"
        buttons[idx]?.setTitle(text, for: .normal)
        let color = bool ? UIColor.white : UIColor.black
        buttons[idx]?.customTitleColor = .init(normal: color, disabled: color, selected: color, hightlight: color)
    }
    
    
    //스켈레톤 로딩뷰 보여주기
    func configureLoadingView(){
        subTitleLabel.isHidden = true
        [titleLabel,
         firstItemContainerView,
         secondItemContainerView,
         thirdItemContainerView,
         moreButton]
            .forEach{
                $0.startSkeletonAnimation(cornerRadius: 8)
            }
    }
    
    func removeLottieAnimationView(){
        subTitleLabel.isHidden = false
        [titleLabel,
         firstItemContainerView,
         secondItemContainerView,
         thirdItemContainerView,
         moreButton]
            .forEach{
                $0?.stopSkeletonAnimation()
            }
        moreButton.backgroundColor = .init(hex: "#33333333")
    }
    
}

extension ActivitySectionCollectionViewCell{
    func bind(){
        
        //MARK: Input
        //더보기 Button
        moreButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                var nextResponder = self.next
                while nextResponder != nil {
                    if let viewController = nextResponder as? UIViewController {
                        if let navController = viewController.navigationController {
                            let nextVC = MoreActivityViewController()
                            navController.pushViewController(nextVC, animated: true)
                            break
                        }
                    }
                    nextResponder = nextResponder?.next
                }
            })
            .disposed(by: disposeBag)
        
        //Follow Buttons
        let buttons = [firstFollowButton, secondFollowButton, thirdFollowButton]
        for(index, button) in buttons.enumerated(){
            button?.rx.tap
                .map{
                    if "\(button?.style ?? ButtonStyle.primary)" != "primary"{
                        return ( false,index)
                    }else{
                        print("\(button?.style ?? ButtonStyle.primary)")
                        return ( true,index)
                    }
                    
                }
                .bind(to: viewModel.input.followButtonTapped)
                .disposed(by: disposeBag)
        }
        
        //MARK: OUTPUT
        viewModel.output.followStatusChanged
            .subscribe(onNext: {[weak self] bool, idx in
                self?.configureButtons(idx: idx, bool: bool)
            })
            .disposed(by: disposeBag)
        
    }
}
