//
//  PurchaseNFTViewController.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/17.
//
import RxSwift

class NFTPurchaseViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let purchaseView = PurchaseNFTView()
    private let viewModel = PurchaseNFTViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        bindEvent()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -70),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])

        purchaseView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(purchaseView)
        
        NSLayoutConstraint.activate([
            purchaseView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            purchaseView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            purchaseView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            purchaseView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            purchaseView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        setupBackButton()
    }
    
    override func bindViewModel() {
        purchaseView.bind(to: viewModel)

        viewModel.output.showPurchaseSuccess.subscribe(onNext: { [weak self] in
        
        }).disposed(by: disposeBag)
        
        viewModel.output.showPurchaseCancel.subscribe(onNext: { [weak self] in
           
        }).disposed(by: disposeBag)
    }
    
    override func bindEvent() {
       
    }
}
