//
//  SoldOutSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit
import RxSwift

class SoldOutSectionCollectionViewCell: UICollectionViewCell {

    
    var soldoutItems = [UserNftEntity]()
    var selectedIdx = 0
    var disposeBag = DisposeBag()
    //일주일 이내, 1개월 6개월, 올한해 버튼
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var weekButton: Buttons!
    
    @IBOutlet weak var oneMonthButton: Buttons!
    
    @IBOutlet weak var sixMonthButton: Buttons!
    
    @IBOutlet weak var yearButton: Buttons!
    
    //첫번째 NFT
    @IBOutlet weak var firstItemContainerView: UIView!
    
    @IBOutlet weak var firstUserNameContainerView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var firstNFTNameLabel: UILabel!
    
    @IBOutlet weak var firstUserNameLabel: UILabel!
    @IBOutlet weak var firstHeightConstraint: NSLayoutConstraint!
    
    //두번째 NFT
    @IBOutlet weak var secondItemContainerView: UIView!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var secondUserNameContainerView: UIView!
    @IBOutlet weak var secondNFTNameLabel: UILabel!
    
    @IBOutlet weak var secondUserNameLabel: UILabel!
    
    
    //세번째 NFT
    @IBOutlet weak var thirdItemContainerView: UIView!
    
    @IBOutlet weak var thirdHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var thirdUserNameContainerView: UIView!
    @IBOutlet weak var thirdNFTNameLabel: UILabel!
    
    @IBOutlet weak var thirdUserNameLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
         configureButtons()
     }
    //선택된 버튼을 설정하고 나머지 버튼의 스타일을 변경하는 함수
    func setSelectedButton(_ selectedButton: Buttons) {
        let allButtons = [weekButton, oneMonthButton, sixMonthButton, yearButton]
        
        for button in allButtons {
            if button === selectedButton {
                button?.style = .primary
            } else {
                button?.style = .dark
            }
        }
    }
    // 각 버튼의 설정을 초기화하고 탭 이벤트를 구독하는 함수
    private func configureButtons() {
        configureButton(weekButton, shape: .round, style: .primary, height: .h36)
        configureButton(oneMonthButton, shape: .round, style: .dark, height: .h36)
        configureButton(sixMonthButton, shape: .round, style: .dark, height: .h36)
        configureButton(yearButton, shape: .round, style: .dark, height: .h36)

        bind()
        
    }
    
    func bind(){
        weekButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let weekButton = self.weekButton else { return }
                self.setSelectedButton(weekButton)
            }
            .disposed(by: disposeBag)
        
        oneMonthButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let oneMonthButton = self.oneMonthButton else { return }
                self.setSelectedButton(oneMonthButton)
            }
            .disposed(by: disposeBag)
        
        sixMonthButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let sixMonthButton = self.sixMonthButton else { return }
                self.setSelectedButton(sixMonthButton)
            }
            .disposed(by: disposeBag)
        
        yearButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let yearButton = self.yearButton else { return }
                self.setSelectedButton(yearButton)
            }
            .disposed(by: disposeBag)
    }
    // 버튼의 모양, 스타일, 높이를 설정하는 함수
    private func configureButton(_ button: Buttons, shape: ButtonsShape, style: ButtonStyle, height: ButtonHeight) {
         button.shape = shape
         button.style = style
         button.buttonHeight = height
     }
    // items를 사용하여 soldoutItems를 설정하고 이미지 뷰를 구성하는 함수
     func configure(items: [UserNftEntity]) {
         //soldoutItems = items
         
         //mock
         soldoutItems = [UserNftEntity(cardId: 28,
                                       userName: "서승환",
                                       cardName: "테스트 크크", imgUrl: "https://metadata-store.klaytnapi.com/eccac2a4-5e45-6ab9-b4ef-32dec2207105/4696abf4-4368-b4c9-7fac-a50e9c8fb3a2.jpg", price: "10000000.000000",
                                       liked: false)]
         if soldoutItems.first?.cardId == -1{
             self.configureLoadingView()
         }
         configureImageViews()
     }
    // 이미지 뷰에 이미지를 설정하고 높이를 조정하는 함수
     private func configureImageViews() {
         let cellHeight = self.contentView.bounds.height
         let numberOfItems = soldoutItems.count

         firstItemContainerView.isHidden = true
         secondItemContainerView.isHidden = true
         thirdItemContainerView.isHidden = true

         if numberOfItems >= 1 {
             configureImageView(firstImageView, item: soldoutItems[0])
             firstItemContainerView.isHidden = false
         }

         if numberOfItems >= 2 {
             configureImageView(secondImageView, item: soldoutItems[1])
             secondItemContainerView.isHidden = false
         }

         if numberOfItems >= 3 {
             configureImageView(thirdImageView, item: soldoutItems[2])
             thirdItemContainerView.isHidden = false
         }
     }

    //이미지 설정
     private func configureImageView(_ imageView: UIImageView, item: UserNftEntity) {
         imageView.kf.setImage(with: URL(string: item.imgUrl), options: [.scaleFactor(CGFloat(1.0))])
         

     }
    
    //스켈레톤 로딩뷰 보여주기
    func configureLoadingView(){
        self.subTitleLabel.isHidden = true
        [titleLabel,
         scrollView,
         self.firstImageView,
         self.firstNFTNameLabel,
         self.firstUserNameContainerView,
         self.secondImageView,
         self.secondNFTNameLabel,
         self.secondUserNameContainerView,
         self.thirdImageView,
         self.thirdNFTNameLabel,
         self.thirdUserNameContainerView,
         self.moreButton
        ]
            .forEach{
                $0.startSkeletonAnimation(cornerRadius: 8)
            }
            
        
    }
    
    func removeLottieAnimationView(){
        self.contentView.stopSkeletonAnimation()
    }
}
