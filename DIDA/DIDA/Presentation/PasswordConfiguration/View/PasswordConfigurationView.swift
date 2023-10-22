//
//  PasswordConfigurationView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/10/16.
//

import UIKit
import RxSwift

class PasswordConfigurationView: UIView {
    
    private enum Constants {
        static let passwordCount = 6
        static let buttonWidth: CGFloat = UIScreen.main.bounds.width / 3
        static let buttonHeight: CGFloat = 50
        static let passwordViewSize: CGFloat = 16
        static let titleLabelTopPadding: CGFloat = 219
        static let subtitleLabelTopPadding: CGFloat = 16
        static let passwordInputStackViewTopPadding: CGFloat = 30
        static let passwordInputStackViewLeadingPadding: CGFloat = 92
        static let passwordInputStackViewTrailingPadding: CGFloat = -92
        static let numberButtonTopPadding: CGFloat = 166
        static let numberButtonVerticalSpacing: CGFloat = 70
        static let lastNumberButtonTopPadding: CGFloat = 166 + CGFloat(3) * 70
        static let deleteButtonHeight: CGFloat = 60
    }
    
    private var currentInputIndex = 0
    var numberButtonTapped: PublishSubject<Int> = PublishSubject()
    var deleteButtonTapped: PublishSubject<Void> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    private let wrongCountLabel : UILabel = {
        let label = UILabel()
        label.text = "1/5"
        label.textColor = Colors.text_notice_red
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 설정"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "6자리 비밀번호를 입력하세요."
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "number_pad_12"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let passwordInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var passwordInputViews: [UIView] = []
    private var numberButtons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .black
        setupLabels()
        setupPasswordViews()
        setupNumberButtons()
        setupDeleteButton()
        setupConstraints()
    }
    
    private func setupLabels() {
        [titleLabel, subtitleLabel, wrongCountLabel].forEach { addSubview($0) }
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func setSubtitle(_ subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
    private func setupPasswordViews() {
        addSubview(passwordInputStackView)
        for _ in 0..<Constants.passwordCount {
            let view = UIView()
            view.layer.cornerRadius = Constants.passwordViewSize / 2
            view.backgroundColor = Colors.border_line
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: Constants.passwordViewSize),
                view.heightAnchor.constraint(equalToConstant: Constants.passwordViewSize)
            ])
            passwordInputViews.append(view)
            passwordInputStackView.addArrangedSubview(view)
        }
    }
    
    private func setupNumberButtons() {
        for i in 1...10 {
            let button = UIButton()
            button.setTitle("\(i % 10)", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            numberButtons.append(button)
            addSubview(button)
        }
        
        numberButtons.enumerated().forEach { index, button in
            let numberToSend = (index + 1) % 10
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.fillNextInputView()
                    self?.numberButtonTapped.onNext(numberToSend)
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func setupDeleteButton() {
        addSubview(deleteButton)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.removeLastInputView()
                self?.deleteButtonTapped.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func fillNextInputView() {
        guard currentInputIndex < passwordInputViews.count else { return }
        passwordInputViews[currentInputIndex].backgroundColor = .yellow
        currentInputIndex += 1
    }
    
    private func removeLastInputView() {
        guard currentInputIndex > 0 else { return }
        currentInputIndex -= 1
        passwordInputViews[currentInputIndex].backgroundColor = Colors.border_line
    }
    
    func resetInputViews() {
        for view in passwordInputViews {
            view.backgroundColor = Colors.border_line
        }
        currentInputIndex = 0
    }
    
    func showWrongCountLabel(with count: Int) {
        wrongCountLabel.text = "\(count)/5"
        wrongCountLabel.isHidden = false
    }

    func hideWrongCountLabel() {
        wrongCountLabel.isHidden = true
    }

    private func setupConstraints() {
        setupLabelConstraints()
        setupPasswordInputStackViewConstraints()
        setupNumberButtonConstraints()
        setupLastNumberButtonAndDeleteButtonConstraints()
    }

    private func setupLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor,
                                            constant: Constants.titleLabelTopPadding),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                               constant: Constants.subtitleLabelTopPadding),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            wrongCountLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor , constant: -10),
            wrongCountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func setupPasswordInputStackViewConstraints() {
        NSLayoutConstraint.activate([
            passwordInputStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor,
                                                        constant: Constants.passwordInputStackViewTopPadding),
            passwordInputStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                            constant: Constants.passwordInputStackViewLeadingPadding),
            passwordInputStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                             constant: Constants.passwordInputStackViewTrailingPadding)
        ])
    }

    private func setupNumberButtonConstraints() {
        for (index, button) in numberButtons.enumerated() {
            if index == 9 { continue }
            let row = index / 3
            let col = index % 3
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
                button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
                button.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: CGFloat(col) * Constants.buttonWidth),
                button.topAnchor.constraint(equalTo: passwordInputViews.last!.bottomAnchor,
                                            constant: Constants.numberButtonTopPadding + CGFloat(row) * Constants.numberButtonVerticalSpacing)
            ])
        }
    }

    private func setupLastNumberButtonAndDeleteButtonConstraints() {
        NSLayoutConstraint.activate([
            numberButtons[9].widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            numberButtons[9].heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            numberButtons[9].centerXAnchor.constraint(equalTo: centerXAnchor),
            numberButtons[9].topAnchor.constraint(equalTo: passwordInputViews.last!.bottomAnchor, constant: Constants.lastNumberButtonTopPadding),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonHeight),
            deleteButton.leadingAnchor.constraint(equalTo: numberButtons[9].trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: numberButtons[8].bottomAnchor, constant: 0)
        ])
    }
}
