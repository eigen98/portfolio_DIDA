//
//  SwapViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit
import RxSwift

class SwapViewController: BaseViewController {
    
    private let swapView = SwapView()
    private let viewModel: SwapViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SwapViewModel = SwapViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SwapViewModel()
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func bindEvent() {
        super.bindEvent()
    }
    
    private func setupUI() {
        self.customTitleBar.title = "Swap"
        view.backgroundColor = .black
        view.addSubview(swapView)
        setupConstraint()
    }
    
    private func setupConstraint() {
        swapView.translatesAutoresizingMaskIntoConstraints = false
        swapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        swapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        swapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        swapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func bindViewModel() {
        let output = viewModel.output
        swapView.bind(to: output)
        viewModel.input.fetchWalletInfoTrigger.onNext(())
    }
}
