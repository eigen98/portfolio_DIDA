//
//  DetailInfoListView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import UIKit
protocol DetailInfoRowViewDelegate: AnyObject {
    func detailInfoRowViewTapped(_ view: DetailInfoRowView, actionType: RowActionType)
}

enum RowActionType {
    case contractLink(String)
    case ownershipDetails
}

class DetailInfoRowView: UIView {
    
    weak var delegate: DetailInfoRowViewDelegate?
    var actionType: RowActionType?
    let height: CGFloat = 28.0
    
    enum RowType {
        case label
        case link
    }
    
    init(title: String, data: String, rowType: RowType, imageName: String? = nil, actionType: RowActionType? = nil) {
            self.actionType = actionType
            super.init(frame: .zero)
            setupViews(for: rowType, title: title, data: data, imageName: imageName)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.setupViews(for: .label, title: "", data: "")
        }

        private func setupViews(for rowType: RowType, title: String, data: String, imageName: String? = nil) {
            switch rowType {
            case .label:
                setupLabelRow(title: title, data: data)
            case .link:
                setupLinkRow(title: title, data: data, imageName: imageName ?? "defaultImageName")
            }
        }

        @objc private func handleBackgroundViewTap() {
            guard let actionType = actionType else { return }
            delegate?.detailInfoRowViewTapped(self, actionType: actionType)
        }
    
    private func setupLabelRow(title: String, data: String) {
        let titleLabel = UILabel()
        titleLabel.font = Fonts.regular_14
        titleLabel.textColor = .white
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dataLabel = UILabel()
        dataLabel.font = Fonts.bold_14
        dataLabel.textColor = Colors.brand_lemon
        dataLabel.text = data
        dataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(dataLabel)
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dataLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dataLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupLinkRow(title: String, data: String, imageName: String) {

        let rowView = UIView()
        rowView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.font = Fonts.regular_14
        titleLabel.textColor = .white
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let backgroundView = UIView()
        backgroundView.backgroundColor = Colors.surface_2
        backgroundView.layer.cornerRadius = 8
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundViewTap))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true

        let dataLabel = UILabel()
        dataLabel.font = Fonts.bold_14
        dataLabel.textColor = Colors.brand_lemon
        dataLabel.text = data
        dataLabel.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Colors.brand_lemon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(rowView)
        rowView.addSubview(titleLabel)
        rowView.addSubview(backgroundView)
        backgroundView.addSubview(dataLabel)
        backgroundView.addSubview(imageView)

        rowView.heightAnchor.constraint(equalToConstant: height).isActive = true

        NSLayoutConstraint.activate([
            rowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            rowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rowView.topAnchor.constraint(equalTo: topAnchor),
            rowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.leadingAnchor, constant: -8),
            
            backgroundView.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: rowView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: rowView.bottomAnchor),
            
            dataLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            dataLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -36),
            dataLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            dataLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.5), 
            
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            
            
        ])
    }

}

class DetailInfoListView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.spacing = 6.0
        self.distribution = .fillEqually
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.axis = .vertical
        self.spacing = 6.0
        self.distribution = .fillEqually
    }

    func addRow(title: String, data: String, type: DetailInfoRowView.RowType, imageName: String? = nil, actionType: RowActionType? = nil) -> DetailInfoRowView {
            let rowView = DetailInfoRowView(title: title, data: data, rowType: type, imageName: imageName, actionType: actionType)
            addArrangedSubview(rowView)
            return rowView
        }
    func reset() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
