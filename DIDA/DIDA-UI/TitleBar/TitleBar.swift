//
//  TitleBar.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/07/09.
//

import UIKit

class TitleBar: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.text_white
        label.font = Fonts.bold_20
        return label
    }()
    
    let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.spacing = 12.0
        return stackView
    }()
    
    let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        stackView.spacing = 12.0
        return stackView
    }()
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title
        }
    }
    
    var leftItems: [UIView]? = nil {
        didSet {
            setLeftItems()
        }
    }
    
    var rightItems: [UIView]? = nil {
        didSet {
            setRightItems()
        }
    }
    
    let previousButton: UIButton = {
        let button = UIButton.init(frame: .init(x: 0, y: 0, width: 28, height: 28))
        button.setImage(UIImage(named: "left_arrows"), for: .normal)
        return button
    }()
    
    convenience init(title: String?) {
        self.init()
        
        self.title = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.backgroundColor = .clear
    }
    
    
    private func setLeftItems() {
        guard let leftItems = leftItems else { return }
        
        self.addSubview(leftStackView)
        leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualTo(self.titleLabel.snp.leading).offset(12)
        }
        
        for item in leftItems {
            self.leftStackView.addArrangedSubview(item)
        }
    }
    
    private func setRightItems() {
        guard let leftItems = rightItems?.reversed() else { return }
        
        self.addSubview(rightStackView)
        rightStackView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
            make.top.bottom.lessThanOrEqualToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        
        for item in leftItems.reversed() {
            self.rightStackView.addArrangedSubview(item)
        }
    }
}
