//
//  MoreSoldoutViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/25.
//

import UIKit
import RxSwift

class MoreSoldoutViewController: BaseViewController {
    
    
    let viewModel = MoreSoldoutViewModel()
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var weekButton: Buttons!
    
    @IBOutlet weak var oneMonthButton: Buttons!
    
    @IBOutlet weak var sixMonthButton: Buttons!
    
    @IBOutlet weak var yearButton: Buttons!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleBar()
        bindViewModel()
        setupCollectionView()
        bindEvent()
        
        activateWeekButton()
    }
    
    override func bindViewModel() {
        viewModel.output.soldoutNFTData
            .bind(to: collectionView.rx.items(cellIdentifier: "SoldoutCollectionViewCell", cellType: SoldoutCollectionViewCell.self)) { index, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.showLoading
            .bind(onNext: { [weak self] isLoading in
               
                if isLoading {
                    self?.showLoadingBlocker()
                    self?.showLoadingSkeletons(count: 10)
                    
                } else {
                    self?.collectionView.refreshControl?.endRefreshing()
                    self?.hideLoadingBlocker()
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    override func bindEvent() {
        collectionView.rx.modelSelected(NFTEntity.self)
            .subscribe(onNext: { item in
                
            })
            .disposed(by: disposeBag)
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.input.refreshTrigger)
            .disposed(by: disposeBag)
        
        weekButton.rx.tap
            .do(onNext: { [weak self] in
                guard let button = self?.weekButton else { return }
                self?.setSelectedButton(button)
            })
            .map { 7 }
            .bind(to: viewModel.input.rangeTrigger)
            .disposed(by: disposeBag)
        
        oneMonthButton.rx.tap
            .do(onNext: { [weak self] in
                guard let button = self?.oneMonthButton else { return }
                self?.setSelectedButton(button)
            })
                .map { 30 }
                .bind(to: viewModel.input.rangeTrigger)
                .disposed(by: disposeBag)
        
        sixMonthButton.rx.tap
            .do(onNext: { [weak self] in
                guard let button = self?.sixMonthButton else { return }
                self?.setSelectedButton(button)
            })
            .map { 180 }
            .bind(to: viewModel.input.rangeTrigger)
            .disposed(by: disposeBag)
        
        yearButton.rx.tap
            .do(onNext: { [weak self] in
                guard let button = self?.yearButton else { return }
                self?.setSelectedButton(button)
            })
            .map { 365 }
            .bind(to: viewModel.input.rangeTrigger)
            .disposed(by: disposeBag)
    }
    
    
    
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width , height: 75)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib(nibName: "SoldoutCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SoldoutCollectionViewCell")
    }
    
    private func setupTitleBar() {
        self.setupBackButton()
        customTitleBar.title = "Sold Out"
    }
    
    private func activateWeekButton() {
        setSelectedButton(weekButton)
        viewModel.input.rangeTrigger.onNext(7)
        viewModel.input.refreshTrigger.onNext(())
    }

    private func showLoadingSkeletons(count: Int) {
        let skeletons = Array(repeating: NFTEntity.loading, count: count)
        viewModel.output.soldoutNFTData.onNext(skeletons)
    }
}
