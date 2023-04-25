//
//  SnackBar.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class SnackBar: UIView {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.surface_2
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    var imageView: UIImageView?
    var title: String?
    var message: String?
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    private var actionhandler: (() -> Void)? = nil

    convenience init(imageView: UIImageView?, title: String?, message: String?) {
        self.init()
        
        self.imageView = imageView
        self.title = title
        self.message = message
    }
    
    convenience init(title: String?, message: String?) {
        self.init()
        
        self.title = title
        self.message = message
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
        self.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(31)
            make.trailing.equalToSuperview().offset(-31)
            make.center.equalToSuperview()
        }
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        self.removeFromSuperview()
    }
    
    public func dismiss() {
        self.hide()
    }
    
    public func addAction(actionItem: SnackBarActionItem) {
        self.buttonStackView.addArrangedSubview(actionItem)
    }
    
    private func addingViews() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        
        if let imageView = imageView {
            let view = UIView()
            view.addSubview(imageView)
            
            stackView.addArrangedSubview(view)
            stackView.setCustomSpacing(24, after: view)
            
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(90)
                make.leading.top.equalToSuperview()
            }
            
            view.snp.makeConstraints { make in
                make.height.equalTo(imageView.snp.height)
            }
        }
        
        if let title = title {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = Fonts.bold_24
            titleLabel.textColor = Colors.text_white
            
            stackView.addArrangedSubview(titleLabel)
            stackView.setCustomSpacing(16, after: titleLabel)
        }
        
        if let message = message {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = Fonts.medium_16
            messageLabel.textColor = Colors.text_white
            
            stackView.addArrangedSubview(messageLabel)
            stackView.setCustomSpacing(32, after: messageLabel)
        }
        
        if (buttonStackView.subviews.count > 0) {
            stackView.addArrangedSubview(buttonStackView)
        }
        
        backgroundView.addSubview(stackView)
        
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(stackView.snp.height).offset(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(24)
            make.trailing.bottom.equalToSuperview().offset(-24)
            make.center.equalToSuperview()
        }
    }
    
    public func show() {
        addingViews()
        
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        
        window.addSubview(self)
        
        self.backgroundColor = Colors.background_dim
        
        self.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
}
