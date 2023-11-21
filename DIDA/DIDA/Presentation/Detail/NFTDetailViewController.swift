//
//  NFTDetailViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import UIKit
import RxSwift
class NFTDetailViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    let viewModel: NFTDetailViewModel = NFTDetailViewModel()
    var nftId: Int? 
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var purchaseButton: Buttons!
    @IBOutlet weak var priceContainerWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceContainerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var likeButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleBar()
        setupButton()
        initCollectionView()
        bindEvent()
        bindViewModel()
        viewModel.input.refreshTrigger.accept((nftId ?? 0))
    }
    
    override func bindEvent() {
        purchaseButton.rx.tap
            .bind(to: viewModel.input.transactionButtonTapped)
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        bindCollectionView()
        bindPriceLabel()
        bindLikeButton()
        bindUIUpdatesBasedOnOwnership()
        bindTransactionResult()
    }

    private func bindCollectionView(){
        viewModel.output.nftDetailData
            .bind(to: collectionView.rx.items) { collectionView, row, item in
                switch item {
                case .overview(let overviewItem):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTOverviewCollectionViewCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! NFTOverviewCollectionViewCell
                    cell.configure(with: overviewItem)
                    cell.delegate = self
                    return cell

                case .detailInfo(let detailInfoItem):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTDetailInfoCollectionViewCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! NFTDetailInfoCollectionViewCell
                    cell.configure(with: detailInfoItem)
                    return cell

                case .community(let communityItem):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCommunityCollectionViewCell.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! NFTCommunityCollectionViewCell
                  
                    cell.configure(with: communityItem)
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindPriceLabel(){
        viewModel.output.priceObservable
            .subscribe(onNext: { [weak self] price in
                self?.priceLabel.text = self?.roundedStringToTwoDecimalPlaces(value: price ?? "0.00")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLikeButton(){
        viewModel.output.likeStatusChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLiked in
                let imageName = isLiked ? "heart-fill-white" : "heart-unfill"
                self?.likeButton.setImage(UIImage(named: imageName), for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUIUpdatesBasedOnOwnership(){
        viewModel.output.nftDetailData
            .map { sectionItems in
                sectionItems.compactMap { $0.overviewData?.isMe }.first ?? false
            }
            .subscribe(onNext: { [weak self] isMe in
                self?.updateUIForOwnership(isOwner: isMe)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTransactionResult() {
        viewModel.output.transactionResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .failure(let error):
                    if let purchaseError = error as? PurchaseNFTErrors,
                        purchaseError == .walletNotExist {
                        self?.showNoWalletAlert()
                    } else {
                        print(error.localizedDescription)
                    }
                case .success:
                    self?.showPasswordConfigurationVC()
                }
            })
            .disposed(by: disposeBag)
    }

    private func showNoWalletAlert() {
        let noWalletVC = NoWalletAlertViewController()
        noWalletVC.modalPresentationStyle = .overCurrentContext
        noWalletVC.modalTransitionStyle = .crossDissolve
        self.present(noWalletVC, animated: true, completion: nil)
       
    }
    
    private func showPasswordConfigurationVC() {
        let passwordConfigurationVC = PasswordConfigurationViewController(with: .enterPassword, context: .nftPurchase(nftId: nftId ?? 0), nftId: nftId)
        passwordConfigurationVC.modalPresentationStyle = .overCurrentContext
        passwordConfigurationVC.modalTransitionStyle = .crossDissolve
        self.present(passwordConfigurationVC, animated: true, completion: nil)
       
    }
    
    private func updateUIForOwnership(isOwner: Bool) {
        priceContainerWidthConstraint.constant = isOwner ? 0 : 148
        priceContainerView.isHidden = isOwner
        purchaseButton.setTitle(isOwner ? "판매하기" : "구매하기", for: .normal)
    }
    
    private func setupTitleBar() {
        self.setupBackButton()
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "more_vertical"), for: .normal)
        customTitleBar.rightItems = [likeButton, menuButton]
    }
    
    @objc func likeButtonTapped() {
        if let nftId = nftId{
            self.viewModel.input.likeButtonTapped.accept(nftId)
        }
    }
    
    private func initCollectionView() {
        collectionView.register(UINib(nibName: NFTOverviewCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NFTOverviewCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: NFTDetailInfoCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NFTDetailInfoCollectionViewCell.reuseIdentifier)
        collectionView.register(UINib(nibName: NFTCommunityCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NFTCommunityCollectionViewCell.reuseIdentifier)
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        self.collectionView.collectionViewLayout = layout
    }
    
    private func setupButton() {
        purchaseButton.style = .dialog
        purchaseButton.shape = .round
    }
    
    private func roundedStringToTwoDecimalPlaces(value: String) -> String {
        if value.isEmpty { return "0.00" }
        
        if let doubleValue = Double(value) {
            let absValue = abs(doubleValue)
            let sign = doubleValue < 0 ? "-" : ""
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            
            let (divisor, suffix): (Double, String) = {
                if absValue < 1_000 { return (1, "") }
                if absValue < 1_000_000 { return (1_000, "K") }
                return (1_000_000, "M")
            }()
            
            let formattedValue = formatter.string(from: NSNumber(value: absValue / divisor)) ?? ""
            return "\(sign)\(formattedValue)\(suffix)"
        } else {
            return value
        }
    }
}

extension NFTDetailViewController : NFTOverviewCollectionViewCellDelegate {
    func didTapFollowButton(onCell cell: NFTOverviewCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        self.viewModel.input.followButtonTapped.accept(())
        
    }
}
