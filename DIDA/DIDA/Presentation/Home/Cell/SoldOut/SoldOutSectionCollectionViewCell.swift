//
//  SoldOutSectionCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/03/06.
//

import UIKit
import RxSwift

class SoldOutSectionCollectionViewCell: UICollectionViewCell {

    var selectedIdx = 0
    var disposeBag = DisposeBag()
    //일주일 이내, 1개월 6개월, 올한해 버튼
    
    //MARK: ViewModel
    let viewModel : SoldOutSectionViewModel = SoldOutSectionViewModel()
    
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
    
    
    @IBOutlet weak var firstUserImageView: UIImageView!
    
    @IBOutlet weak var firstUserNameLabel: UILabel!
    
    
    @IBOutlet weak var firstPriceLabel: UILabel!
    
    @IBOutlet weak var firstHeightConstraint: NSLayoutConstraint!
    
    //두번째 NFT
    @IBOutlet weak var secondItemContainerView: UIView!
    
    @IBOutlet weak var secondHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var secondUserNameContainerView: UIView!
    
    @IBOutlet weak var secondUserImageView: UIImageView!
    
    @IBOutlet weak var secondNFTNameLabel: UILabel!
    
    @IBOutlet weak var secondUserNameLabel: UILabel!
    
    @IBOutlet weak var secondPriceLabel: UILabel!
    
    
    
    //세번째 NFT
    @IBOutlet weak var thirdItemContainerView: UIView!
    
    @IBOutlet weak var thirdHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var thirdUserNameContainerView: UIView!
    
    
    @IBOutlet weak var thirdUserImageView: UIImageView!
    
    @IBOutlet weak var thirdNFTNameLabel: UILabel!
    
    @IBOutlet weak var thirdUserNameLabel: UILabel!
    
    
    @IBOutlet weak var thirdPriceLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButtons()
        bindViewModel()
    }
    
    
    func bindViewModel() {

        viewModel.output.isRefreshing
            .subscribe(onNext: {[weak self] isLoading in
                
                if isLoading{
                    [self?.firstItemContainerView,
                     self?.secondItemContainerView,
                     self?.thirdItemContainerView].forEach{
                        $0?.isHidden = false
                    }
                    self?.showSkeleton(usingColor: Colors.surface_2!)
                    
                }else{
                    self?.hideSkeleton()
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.output.soldoutOutput
            .subscribe(onNext: {[weak self] items in
                self?.configure(items: items)
            }).disposed(by: disposeBag)
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

        moreButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let viewController = self?.parentViewController,
                      let navController = viewController.navigationController else { return }
                
                let nextVC = MoreSoldoutViewController()
                navController.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)

        weekButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let weekButton = self.weekButton else { return }
                
                self.setSelectedButton(weekButton)
                
                self.viewModel.input
                    .refreshTrigger.onNext(7)
            }
            .disposed(by: disposeBag)
        
        oneMonthButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let oneMonthButton = self.oneMonthButton else { return }
                self.setSelectedButton(oneMonthButton)
                
                self.viewModel.input
                    .refreshTrigger.onNext(30)
            }
            .disposed(by: disposeBag)
        
        sixMonthButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let sixMonthButton = self.sixMonthButton else { return }
                self.setSelectedButton(sixMonthButton)
                
                self.viewModel.input
                    .refreshTrigger.onNext(180)
            }
            .disposed(by: disposeBag)
        
        yearButton.rx.tap
            .bind { [weak self] in
                guard let self = self, let yearButton = self.yearButton else { return }
                self.setSelectedButton(yearButton)
                
                self.viewModel.input
                    .refreshTrigger.onNext(365)
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
     func configure(items: [NFTEntity]) {
         configureImageViews(with: items)
     }
    // 이미지 뷰에 이미지를 설정하고 높이를 조정하는 함수
    private func configureImageViews(with items: [NFTEntity]) {
        let numberOfItems = items.count
        
        firstItemContainerView.isHidden = true
        secondItemContainerView.isHidden = true
        thirdItemContainerView.isHidden = true
        
        if numberOfItems >= 1 {
            configureImageView(firstImageView, item: items[0])
            firstNFTNameLabel.text = items[0].nftName
            firstUserNameLabel.text = items[0].nickname
            firstPriceLabel.text =  roundedStringToTwoDecimalPlaces(value: items[0].price)
            firstItemContainerView.isHidden = false
        }
        
        if numberOfItems >= 2 {
            configureImageView(secondImageView, item: items[1])
            secondNFTNameLabel.text = items[1].nftName
            secondUserNameLabel.text = items[1].nickname
            secondPriceLabel.text = roundedStringToTwoDecimalPlaces(value: items[1].price)
            secondItemContainerView.isHidden = false
        }
        
        if numberOfItems >= 3 {
            configureImageView(thirdImageView, item: items[2])
            thirdNFTNameLabel.text = items[2].nftName
            thirdUserNameLabel.text = items[2].nickname
            thirdPriceLabel.text =  roundedStringToTwoDecimalPlaces(value: items[2].price)
            thirdItemContainerView.isHidden = false
        }
    }
    

    //이미지 설정
     private func configureImageView(_ imageView: UIImageView, item: NFTEntity) {
         imageView.kf.setImage(with: URL(string: item.nftImg), options: [.scaleFactor(CGFloat(1.0))])
         
     }
    
    
    /*
     String 값을 소수점 둘째 자리 수까지 반올림하는 함수.
     */
    func roundedStringToTwoDecimalPlaces(value: String) -> String {
        if value == ""{ return "00.00"}
        if let doubleValue = Double(value) {
            let roundedValue = round(doubleValue * 100) / 100
            return String(format: "%.2f", roundedValue)
        }
        
        return "00.00"
    }
}


