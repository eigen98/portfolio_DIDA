//
//  PurchaseNFTView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/17.
//

import UIKit
import RxSwift

class PurchaseNFTView : UIView{

    let nftInfoTitleLabel = UILabel()
    let nftImageView = UIImageView()
    let nftNameLabel = UILabel()
    let usernameLabel = UILabel()
    let nftSalePriceLabel = UILabel()
    
    let myDidaTitleLabel = UILabel()
    let didaBalanceLabel = UILabel()
    let didaBalanceValueLabel = UILabel()
    
    let paymentInfoTitleLabel = UILabel()
    let paymentInfoPriceLabel = UILabel()
    let paymentInfoPriceValueLabel = UILabel()
    
    let feePriceLabel = UILabel()
    let feeQuestionButton = UIButton()
    let feePriceValueLabel = UILabel()
    
    let totalPriceLabel = UILabel()
    let totalPriceValueLabel = UILabel()
    let remainingBalanceAfterPaymentLabel = UILabel()
    let remainingBalanceAfterPaymentValueLabel = UILabel()
    
    let ownershipHistoryView : UIView =  {
        let view = UIView()
        view.backgroundColor = Colors.surface_2
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    let ownershipHistoryTitleLabel = UILabel()
    let nftSellerLabel = UILabel()
    let nftBuyerLabel = UILabel()
 
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSeparatorFrames()
    }
    
    private func setupUI() {
        self.backgroundColor = .black

        [nftInfoTitleLabel, nftImageView,
         nftNameLabel, usernameLabel,
         nftSalePriceLabel, myDidaTitleLabel,
         didaBalanceLabel,didaBalanceValueLabel,
         paymentInfoTitleLabel,paymentInfoPriceValueLabel,
         paymentInfoPriceLabel, feePriceLabel,
         feePriceValueLabel, feeQuestionButton,
         totalPriceLabel,totalPriceValueLabel,
         remainingBalanceAfterPaymentLabel, remainingBalanceAfterPaymentValueLabel,
         ownershipHistoryView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [ ownershipHistoryTitleLabel,
          nftSellerLabel,nftBuyerLabel,
        ].forEach{
            ownershipHistoryView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupLabels()
        setupImageViews()
        setupButtons()
        setupConstraints()
    }
    
    private func setupLabels() {
        nftInfoTitleLabel.text = "NFT 정보"
        nftNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        usernameLabel.font = UIFont.systemFont(ofSize: 18)
        nftSalePriceLabel.text = "00.0 dida"
        
        myDidaTitleLabel.text = "MyDida"
        didaBalanceLabel.text = "보유"
        didaBalanceValueLabel.text = "5000 dida"
        
        paymentInfoTitleLabel.text = "결제 정보"
        paymentInfoTitleLabel.textColor = .white
        paymentInfoPriceLabel.text = "판매 가격"
        paymentInfoPriceLabel.textColor = .white
        paymentInfoPriceValueLabel.text = "324.91 dida"
        
        feePriceLabel.text = "수수료"
        feePriceLabel.textColor = .white
        feePriceValueLabel.text = "123 dida"
        
        totalPriceLabel.text = "총액"
        totalPriceLabel.textColor = Colors.brand_lemon
        totalPriceValueLabel.text = "447.91 dida"
        
        remainingBalanceAfterPaymentLabel.text = "결제 후 잔액"
        remainingBalanceAfterPaymentLabel.textColor = .white
        remainingBalanceAfterPaymentValueLabel.text = "4552.09 dida"
        
        ownershipHistoryTitleLabel.text = "구매 완료시 소유권이 변동됩니다."
        
        nftSellerLabel.text = "user name 판매자"
        nftSellerLabel.textColor = Colors.surface_6
        
        nftBuyerLabel.text = "user name 구매자"
        nftBuyerLabel.textColor = Colors.brand_lemon
        
    }
    
    private func setupImageViews() {
        nftImageView.contentMode = .scaleAspectFit
        nftImageView.layer.cornerRadius = 8
        nftImageView.clipsToBounds = true
        nftImageView.backgroundColor = .gray
    }
    
    private func setupButtons() {
        feeQuestionButton.setImage(UIImage(named: "question-line"), for: .normal)
    }
    
    private func setupConstraints() {
        setupNFTInfoConstraints()
        
        setupMyDidaConstraints()
        
        setupPaymentInfoConstraints()
        
        setupTotalPriceAndBalanceConstraints()
        
        setupOwnershipHistoryConstraints()
    }
    
    private func setupNFTInfoConstraints() {
        NSLayoutConstraint.activate([
            nftInfoTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            nftInfoTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            nftImageView.topAnchor.constraint(equalTo: nftInfoTitleLabel.bottomAnchor, constant: 14),
            nftImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            nftImageView.widthAnchor.constraint(equalToConstant: 81),
            nftImageView.heightAnchor.constraint(equalToConstant: 81),
            
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 18),
            
            usernameLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 2),
            usernameLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            
            nftSalePriceLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 12),
            nftSalePriceLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor)
        ])
    }
    
    private func setupMyDidaConstraints() {
        NSLayoutConstraint.activate([
            myDidaTitleLabel.topAnchor.constraint(equalTo: nftSalePriceLabel.bottomAnchor, constant: 62),
            myDidaTitleLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            
            didaBalanceLabel.topAnchor.constraint(equalTo: myDidaTitleLabel.bottomAnchor, constant: 16),
            didaBalanceLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            
            didaBalanceValueLabel.topAnchor.constraint(equalTo: myDidaTitleLabel.bottomAnchor, constant: 16),
            didaBalanceValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupPaymentInfoConstraints() {
        NSLayoutConstraint.activate([
            paymentInfoTitleLabel.topAnchor.constraint(equalTo: didaBalanceLabel.bottomAnchor, constant: 53),
            paymentInfoTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            paymentInfoPriceLabel.topAnchor.constraint(equalTo: paymentInfoTitleLabel.bottomAnchor, constant: 16),
            paymentInfoPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            paymentInfoPriceValueLabel.topAnchor.constraint(equalTo: paymentInfoTitleLabel.bottomAnchor, constant: 16),
            paymentInfoPriceValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            feePriceLabel.topAnchor.constraint(equalTo: paymentInfoPriceLabel.bottomAnchor, constant: 18),
            feePriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            feePriceValueLabel.topAnchor.constraint(equalTo: paymentInfoPriceLabel.bottomAnchor, constant: 18),
            feePriceValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            feeQuestionButton.centerYAnchor.constraint(equalTo: feePriceLabel.centerYAnchor),
            feeQuestionButton.leadingAnchor.constraint(equalTo: feePriceLabel.trailingAnchor, constant: 4),
            feeQuestionButton.widthAnchor.constraint(equalToConstant: 16),
            feeQuestionButton.heightAnchor.constraint(equalToConstant: 16)
        ])
        
    }
    
    private func setupTotalPriceAndBalanceConstraints() {
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: feePriceLabel.bottomAnchor, constant: 58),
            totalPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            totalPriceValueLabel.topAnchor.constraint(equalTo: feePriceLabel.bottomAnchor, constant: 58),
            totalPriceValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            remainingBalanceAfterPaymentLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 14),
            remainingBalanceAfterPaymentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            remainingBalanceAfterPaymentValueLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 14),
            remainingBalanceAfterPaymentValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }

    private func setupOwnershipHistoryConstraints() {
        
        let imageView = UIImageView(image: UIImage(named: "line23"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        ownershipHistoryView.addSubview(imageView)
        
        
        NSLayoutConstraint.activate([
            ownershipHistoryView.topAnchor.constraint(equalTo: remainingBalanceAfterPaymentLabel.bottomAnchor, constant: 32),
            ownershipHistoryView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            ownershipHistoryView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            ownershipHistoryView.heightAnchor.constraint(equalToConstant: 127),
            ownershipHistoryView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -38),
            
            ownershipHistoryTitleLabel.topAnchor.constraint(equalTo: ownershipHistoryView.topAnchor, constant: 16),
            ownershipHistoryTitleLabel.leadingAnchor.constraint(equalTo: ownershipHistoryView.leadingAnchor, constant: 16),
            
            imageView.topAnchor.constraint(equalTo: ownershipHistoryTitleLabel.bottomAnchor, constant: 26),
            imageView.leadingAnchor.constraint(equalTo: ownershipHistoryView.leadingAnchor, constant: 16),
            
            nftSellerLabel.topAnchor.constraint(equalTo: ownershipHistoryTitleLabel.bottomAnchor, constant: 14),
            nftSellerLabel.leadingAnchor.constraint(equalTo: ownershipHistoryView.leadingAnchor, constant: 28),
            
            nftBuyerLabel.topAnchor.constraint(equalTo: nftSellerLabel.bottomAnchor, constant: 10),
            nftBuyerLabel.leadingAnchor.constraint(equalTo: ownershipHistoryView.leadingAnchor, constant: 28)
        ])
    }

  

    private func updateSeparatorFrames() {
        let separator1 = CALayer()
        separator1.backgroundColor = Colors.surface_1?.cgColor
        separator1.frame = CGRect(x: 0,
                                  y: nftImageView.frame.maxY + 32,
                                  width: self.frame.width,
                                  height: 8)
        self.layer.addSublayer(separator1)
        
        let separator2 = CALayer()
        separator2.backgroundColor = Colors.surface_1?.cgColor
        separator2.frame = CGRect(x: 0,
                                  y: didaBalanceLabel.frame.maxY + 26,
                                  width: self.frame.width,
                                  height: 8)
        self.layer.addSublayer(separator2)
        
        let separator3 = CALayer()
        separator3.backgroundColor = Colors.surface_6?.cgColor
        separator3.frame = CGRect(x: 0,
                                  y: feePriceLabel.frame.maxY + 30,
                                  width: self.frame.width,
                                  height: 1)
        self.layer.addSublayer(separator3)
    }

    func bind(to viewModel: PurchaseNFTViewModel) {
        viewModel.output.nftImage
            .bind(to: nftImageView.rx.image)
            .disposed(by: disposeBag)
        viewModel.output.nftName
            .bind(to: nftNameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.username
            .bind(to: usernameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.didaBalance
            .bind(to: didaBalanceValueLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.paymentInfoPrice
            .bind(to: paymentInfoPriceValueLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.feePrice
            .bind(to: feePriceValueLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.totalPrice
            .bind(to: totalPriceValueLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.remainingBalanceAfterPayment
            .bind(to: remainingBalanceAfterPaymentValueLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
