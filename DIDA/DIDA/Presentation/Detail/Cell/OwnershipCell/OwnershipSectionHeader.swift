//
//  OwnershipSectionHeader.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/30.
//

import UIKit

class OwnershipSectionHeader: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.bold_18
        titleLabel.textColor = .white
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
