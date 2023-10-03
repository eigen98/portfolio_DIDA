//
//  NFTDetailInfoCollectionViewCell.swift
//  DIDA
//
//  Created by JeongMin Ko on 2023/09/28.
//

import UIKit

class NFTDetailInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var infoListViewContainer: UIView!
    private var detailInfoListView: DetailInfoListView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDetailInfoListView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailInfoListView?.reset()
        hideSkeleton()
    }

    func configure(with data: DetailInfoData?) {
        
        guard let data = data else {
            showSkeleton()
            return
        }
        hideSkeleton()

        let info: [(title: String,
                    data: String,
                    type: DetailInfoRowView.RowType,
                    imageName: String?,
                    actionType: RowActionType?)] = [
            
            (title: "가격", data: data.price + " dida", type: .label, imageName: nil, actionType: nil),
            (title: "토큰 ID", data: data.tokenId, type: .label, imageName: nil, actionType: nil),
            (title: "컨트랙트 링크 주소", data: data.contractAddress, type: .link, imageName: "link-m", actionType: .contractLink(data.contractAddress)),
            (title: "소유권 내역", data: "자세히보기", type: .link, imageName: "file-list-3-line", actionType: .ownershipDetails)
        ]

        configureWithInfo(info)
    }

    private func setupDetailInfoListView() {
        detailInfoListView = DetailInfoListView()
        guard let listView = detailInfoListView else{ return }
        listView.translatesAutoresizingMaskIntoConstraints = false
        infoListViewContainer.addSubview(listView)

        NSLayoutConstraint.activate([
            listView.topAnchor.constraint(equalTo: infoListViewContainer.topAnchor),
            listView.bottomAnchor.constraint(equalTo: infoListViewContainer.bottomAnchor),
            listView.leadingAnchor.constraint(equalTo: infoListViewContainer.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: infoListViewContainer.trailingAnchor)
        ])
    }

    func configureWithInfo(_ info: [(title: String,
                                     data: String,
                                     type: DetailInfoRowView.RowType,
                                     imageName: String?,
                                     actionType: RowActionType?)]) {
        info.forEach { (title, data, type, imageName, actionType) in
            let rowView = detailInfoListView?.addRow(title: title,
                                                    data: data,
                                                    type: type,
                                                    imageName: imageName,
                                                    actionType: actionType)
            rowView?.delegate = self
        }
    }

    func setupSeparator() {
        let separatorHeight: CGFloat = 8.0
        let separator = CALayer()
        separator.backgroundColor = UIColor.separator.cgColor
        separator.frame = CGRect(x: 0, y: self.bounds.height - separatorHeight, width: self.bounds.width, height: separatorHeight)
        self.layer.addSublayer(separator)
    }
}

extension NFTDetailInfoCollectionViewCell: DetailInfoRowViewDelegate {
    func detailInfoRowViewTapped(_ view: DetailInfoRowView, actionType: RowActionType) {
        switch actionType {
        case .contractLink(let address):
            print("컨트랙트 링크 주소를 탭했습니다: \(address)")
        case .ownershipDetails:
            guard let viewController = self.parentViewController,
                  let navController = viewController.navigationController else { return }
            
            let nextVC = OwnershipNFTViewController()
            navController.pushViewController(nextVC, animated: true)
        }
    }
}
