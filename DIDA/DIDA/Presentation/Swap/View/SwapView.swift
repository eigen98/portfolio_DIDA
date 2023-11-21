//
//  SwapView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/21.
//

import UIKit
import RxSwift

class SwapView: UIView {
    
    private enum Constants{
        static var separatorHeight = 8.0
    }
    
    private let disposeBag = DisposeBag()
    
    // 보유자산
    private let assetTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "보유자산"
        label.font = Fonts.bold_20
        return label
    }()
    
    private let assetAmountLabel : UILabel = {
        let label = UILabel()
        label.text = "20.098615"
        label.font = Fonts.semi_bold_20
        label.textColor = Colors.brand_lemon
        return label
    }()
    
    private let assetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let assetNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Klay"
        return label
    }()
    
    private let assetArrowButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "arrow-up-down-line"), for: .normal)
        return button
    }()
    
    // 보내는 코인
    private let sendCoinContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.surface_1
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let sendCoinTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "보내는 코인"
        label.font = Fonts.regular_13
        label.textColor = .white
        return label
    }()
    
    private let sendCoinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let sendCoinNameLabel: UILabel = {
        let label = UILabel()
        label.text = "KLAY"
        label.font = Fonts.bold_16
        return label
    }()
    
    private let sendCoinAmountLabel : UILabel = {
        let label = UILabel()
        label.text = "1.000000"
        label.font = Fonts.bold_20
        return label
    }()

    // 받는 코인
    private let receiveCoinContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = Colors.surface_1
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let receiveCoinTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "받는 코인"
        label.font = Fonts.regular_13
        label.textColor = .white
        return label
    }()
    
    private let receiveCoinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let receiveCoinNameLabel: UILabel = {
        let label = UILabel()
        label.text = "DIDA"
        label.font = Fonts.bold_16
        return label
    }()
    
    private let receiveCoinAmountLabel : UILabel = {
        let label = UILabel()
        label.text = "1.000000"
        label.font = Fonts.bold_20
        return label
    }()
    
    private let flipButton : UIButton = {
        let button = UIButton()
         button.setImage(UIImage(named: "icon_swap"), for: .normal)
         return button
     }()
    
    // 예상내역
    private let expectedDetailsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "예상내역"
        label.font = Fonts.bold_20
        return label
    }()
    
    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.text = "교환비율"
        label.font = Fonts.regular_14
        return label
    }()
    
    private let exchangeRateValueLabel : UILabel = {
        let label = UILabel()
        label.text = "1 DIDA = 1 KLAY"
        label.font = Fonts.bold_14
        label.textColor = Colors.brand_lemon
        return label
    }()

    private let minimumTradeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "최소 거래 수량"
        label.font = Fonts.regular_14
        return label
    }()
    
    private let minimumTradeValueLabel : UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = Fonts.bold_14
        label.textColor = Colors.brand_lemon
        return label
    }()
    
    private let feeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.regular_14
        label.text = "수수료"
        return label
    }()
    
    private let feeValueLabel : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = Fonts.bold_14
        label.textColor = Colors.brand_lemon
        return label
    }()
    private let exchangePathTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.regular_14
        label.text = "교환 경로"
        return label
    }()
    
    private let exchangePathValueLabel : UILabel = {
        let label = UILabel()
        label.text = "KLAY -> DIDA"
        label.font = Fonts.bold_14
        label.textColor = Colors.brand_lemon
        return label
    }()
    
    // 스왑하기 버튼
    private let swapButton : Buttons = {
        let button = Buttons()
        button.style = .primary
        button.shape = .round
        button.buttonHeight = .h56
        button.setTitle("스왑하기", for: .normal)
        return button
     }()
    
    let swapButtonTapped = PublishSubject<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind(to viewModel: SwapViewModel) {
        
        viewModel.output.walletKlayBalance
            .bind(to: assetAmountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.sendingCoin
            .subscribe(onNext: { [weak self] coin in
                self?.updateSendingCoin(coin)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.receivingCoin
            .subscribe(onNext: { [weak self] coin in
                self?.updateReceivingCoin(coin)
            })
            .disposed(by: disposeBag)
        
        flipButton.rx.tap
            .bind { _ in
                viewModel.flipCoins()
            }
            .disposed(by: disposeBag)
        
        swapButton.rx.tap
            .bind(to: swapButtonTapped)
            .disposed(by: disposeBag)
    }
    
    
    private func setupUI() {
        backgroundColor = .black
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        let views: [UIView] = [
            assetTitleLabel, assetAmountLabel, assetImageView, assetNameLabel, assetArrowButton,
            sendCoinContainerView, sendCoinTitleLabel, sendCoinImageView, sendCoinNameLabel, sendCoinAmountLabel,
            receiveCoinContainerView, receiveCoinTitleLabel, receiveCoinImageView, receiveCoinNameLabel, receiveCoinAmountLabel, flipButton,
            expectedDetailsTitleLabel, exchangeRateLabel, exchangeRateValueLabel,
            minimumTradeTitleLabel, minimumTradeValueLabel, feeTitleLabel, feeValueLabel,
            exchangePathTitleLabel, exchangePathValueLabel,
            swapButton
        ]
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupAssetConstraints()
        setupSendCoinConstraints()
        setupReceiveCoinConstraints()
        setupExpectedDetailsConstraints()
        setupSwapButtonConstraints()
        setupSeparator()
    }
    
    private func setupAssetConstraints() {
        NSLayoutConstraint.activate([
            assetTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            assetTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            assetAmountLabel.topAnchor.constraint(equalTo: assetTitleLabel.bottomAnchor, constant: 10),
            assetAmountLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            assetArrowButton.centerYAnchor.constraint(equalTo: assetAmountLabel.centerYAnchor),
            assetArrowButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            assetNameLabel.centerYAnchor.constraint(equalTo: assetAmountLabel.centerYAnchor),
            assetNameLabel.trailingAnchor.constraint(equalTo: assetArrowButton.leadingAnchor, constant: -4),
            assetImageView.centerYAnchor.constraint(equalTo: assetAmountLabel.centerYAnchor),
            assetImageView.trailingAnchor.constraint(equalTo: assetNameLabel.leadingAnchor, constant: -4),
            assetImageView.heightAnchor.constraint(equalToConstant: 24),
            assetImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupSendCoinConstraints() {
        NSLayoutConstraint.activate([
            sendCoinContainerView.topAnchor.constraint(equalTo: assetAmountLabel.bottomAnchor, constant: 8),
            sendCoinContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            sendCoinContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            sendCoinContainerView.heightAnchor.constraint(equalToConstant: 88),
            sendCoinTitleLabel.topAnchor.constraint(equalTo: sendCoinContainerView.topAnchor, constant: 18),
            sendCoinTitleLabel.leadingAnchor.constraint(equalTo: sendCoinContainerView.leadingAnchor, constant: 18),
            sendCoinImageView.topAnchor.constraint(equalTo: sendCoinTitleLabel.bottomAnchor, constant: 10),
            sendCoinImageView.leadingAnchor.constraint(equalTo: sendCoinContainerView.leadingAnchor, constant: 18),
            sendCoinImageView.widthAnchor.constraint(equalToConstant: 24),
            sendCoinImageView.heightAnchor.constraint(equalToConstant: 24),
            sendCoinNameLabel.centerYAnchor.constraint(equalTo: sendCoinImageView.centerYAnchor),
            sendCoinNameLabel.leadingAnchor.constraint(equalTo: sendCoinImageView.trailingAnchor, constant: 8),
            sendCoinAmountLabel.trailingAnchor.constraint(equalTo: sendCoinContainerView.trailingAnchor, constant: -18),
            sendCoinAmountLabel.centerYAnchor.constraint(equalTo: sendCoinContainerView.centerYAnchor)
        ])
    }
    
    private func setupReceiveCoinConstraints() {
        NSLayoutConstraint.activate([
            receiveCoinContainerView.topAnchor.constraint(equalTo: sendCoinContainerView.bottomAnchor, constant: 8),
            receiveCoinContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            receiveCoinContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            receiveCoinContainerView.heightAnchor.constraint(equalToConstant: 88),
            receiveCoinTitleLabel.topAnchor.constraint(equalTo: receiveCoinContainerView.topAnchor, constant: 18),
            receiveCoinTitleLabel.leadingAnchor.constraint(equalTo: receiveCoinContainerView.leadingAnchor, constant: 18),
            receiveCoinImageView.topAnchor.constraint(equalTo: receiveCoinTitleLabel.bottomAnchor, constant: 10),
            receiveCoinImageView.leadingAnchor.constraint(equalTo: receiveCoinContainerView.leadingAnchor, constant: 18),
            receiveCoinImageView.widthAnchor.constraint(equalToConstant: 24),
            receiveCoinImageView.heightAnchor.constraint(equalToConstant: 24),
            receiveCoinNameLabel.centerYAnchor.constraint(equalTo: receiveCoinImageView.centerYAnchor),
            receiveCoinNameLabel.leadingAnchor.constraint(equalTo: receiveCoinImageView.trailingAnchor, constant: 8),
            receiveCoinAmountLabel.trailingAnchor.constraint(equalTo: receiveCoinContainerView.trailingAnchor, constant: -18),
            receiveCoinAmountLabel.centerYAnchor.constraint(equalTo: receiveCoinContainerView.centerYAnchor),
            flipButton.topAnchor.constraint(equalTo: sendCoinContainerView.bottomAnchor, constant: -18),
            flipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            flipButton.widthAnchor.constraint(equalToConstant: 44),
            flipButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupExpectedDetailsConstraints() {
        NSLayoutConstraint.activate([
            expectedDetailsTitleLabel.topAnchor.constraint(equalTo: receiveCoinContainerView.bottomAnchor, constant: 87),
            expectedDetailsTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            exchangeRateLabel.topAnchor.constraint(equalTo: expectedDetailsTitleLabel.bottomAnchor, constant: 16),
            exchangeRateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            exchangeRateValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            exchangeRateValueLabel.centerYAnchor.constraint(equalTo: exchangeRateLabel.centerYAnchor),
            minimumTradeTitleLabel.topAnchor.constraint(equalTo: exchangeRateLabel.bottomAnchor, constant: 9),
            minimumTradeTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            minimumTradeValueLabel.centerYAnchor.constraint(equalTo: minimumTradeTitleLabel.centerYAnchor),
            minimumTradeValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            feeTitleLabel.topAnchor.constraint(equalTo: minimumTradeValueLabel.bottomAnchor, constant: 9),
            feeTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            feeValueLabel.centerYAnchor.constraint(equalTo: feeTitleLabel.centerYAnchor),
            feeValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            exchangePathTitleLabel.topAnchor.constraint(equalTo: feeValueLabel.bottomAnchor, constant: 9),
            exchangePathTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            exchangePathValueLabel.centerYAnchor.constraint(equalTo: exchangePathTitleLabel.centerYAnchor),
            exchangePathValueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22)
        ])
    }
    
    private func setupSwapButtonConstraints() {
        NSLayoutConstraint.activate([
            swapButton.topAnchor.constraint(equalTo: exchangePathTitleLabel.bottomAnchor, constant: 56),
            swapButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            swapButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22),
            swapButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupSeparator() {
        let separator = UIView()
        separator.backgroundColor = Colors.surface_1
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: CGFloat(Constants.separatorHeight)),
            separator.topAnchor.constraint(equalTo: receiveCoinContainerView.bottomAnchor, constant: 57)
        ])
    }
    
    private func updateSendingCoin(_ coin: CoinEntity) {
        let imageName = coin.type == .dida ? "dida_img" : "klay_img"
        sendCoinAmountLabel.text = "\(coin.amount)"
        sendCoinNameLabel.text = coin.type.rawValue
        sendCoinImageView.image = UIImage(named: imageName)
        assetImageView.image = UIImage(named: imageName)
        assetAmountLabel.text = "\(coin.amount)"
        assetNameLabel.text = coin.type.rawValue
        updateExchangePath()
    }
    
    private func updateReceivingCoin(_ coin: CoinEntity) {
        let imageName = coin.type == .dida ? "dida_img" : "klay_img"
        receiveCoinAmountLabel.text = "\(coin.amount)"
        receiveCoinNameLabel.text = coin.type.rawValue
        receiveCoinImageView.image = UIImage(named: imageName)
        updateExchangePath()
    }
    
    private func updateExchangePath() {
        let sendCoinType = sendCoinNameLabel.text ?? ""
        let receiveCoinType = receiveCoinNameLabel.text ?? ""
        exchangePathValueLabel.text = "\(sendCoinType) -> \(receiveCoinType)"
    }

}
