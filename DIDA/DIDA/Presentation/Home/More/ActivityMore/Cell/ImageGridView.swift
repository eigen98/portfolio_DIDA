//
//  ImageGridView.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/27.
//

import UIKit

class ImageGridView: UIView {
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func configure(with imageUrls: [URL?]) {
        mainStackView.arrangedSubviews.forEach { view in
            mainStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let numberOfRows = 2
        let numberOfColumns = 5
        for _ in 0..<numberOfRows {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            
            for j in 0..<numberOfColumns {
                let index = j + numberOfColumns / numberOfRows
                let imageView = createImageView(with: index < imageUrls.count ? imageUrls[index] : nil)
                horizontalStackView.addArrangedSubview(imageView)
            }
            
            mainStackView.addArrangedSubview(horizontalStackView)
        }
    }


    
    private func createImageView(with url: URL?) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.setImage(with: url)
        return imageView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
