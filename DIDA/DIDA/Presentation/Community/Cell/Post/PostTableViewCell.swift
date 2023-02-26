//
//  PostTableViewCell.swift
//  DIDA
//
//  Created by HeecheolYoon on 2023/02/26.
//

import UIKit
import RxCocoa
import RxSwift

//MARK: dynamic한 뷰에서 테이블뷰의 높이가 안정해졌을때 테이블뷰 보이게 하기 위한 클래스
final class DynamicTableView: UITableView {

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet {
        self.invalidateIntrinsicContentSize()
    }
  }
}

final class PostTableViewCell: UITableViewCell {

    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var profileImageView: Profile!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var nftImageView: UIImageView!
    @IBOutlet weak var nftNameLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var commentTableView: DynamicTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension PostTableViewCell {
    private func configure() {
        //프로필
        profileImageView.defaultImage()
        nameLabel.font = Fonts.bold_15
        
        //게시물
        postTitleLabel.font = Fonts.bold_16
        postBodyLabel.font = Fonts.regular_14
        
        //NFT 정보
        nftImageView.layer.cornerRadius = 6
        nftImageView.backgroundColor = Colors.brand_lemon_100 //임시
        nftNameLabel.font = Fonts.regular_14
        coinImageView.layer.cornerRadius = coinImageView.frame.size.width / 2
        coinImageView.backgroundColor = Colors.brand_ivory //임시
        priceLabel.font = Fonts.semi_bold_12
        
        //CommentTableView
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(UINib(nibName: CommentTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
}

extension PostTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //MARK: - 데이터가 2개보다 많으면 3, 2개보다 적으면 개수만큼
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: - 뷰모델 데이터 개수 확인해서 2개보다 많은 경우랑 아닌 경우 분기처리해야할듯
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        
        cell.commentLabel.text = "12312321312312312321312312312"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
