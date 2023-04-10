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
    
    
    @IBOutlet weak var weekButton: Buttons!
    
    @IBOutlet weak var oneMonthButton: Buttons!
    
    @IBOutlet weak var sixMonthButton: Buttons!
    
    @IBOutlet weak var yearButton: Buttons!
    
    //첫번째 NFT
    @IBOutlet weak var firstItemContainerView: UIView!
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var firstHeightConstraint: NSLayoutConstraint!
    
    //두번째 NFT
    @IBOutlet weak var secondItemContainerView: UIView!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    
    //세번째 NFT
    @IBOutlet weak var thirdItemContainerView: UIView!
    
    @IBOutlet weak var thirdHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thirdImageView: UIImageView!
    
    
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
         soldoutItems = items
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
         imageView.kf.setImage(with: URL(string: item.imgUrl))

     }
}
