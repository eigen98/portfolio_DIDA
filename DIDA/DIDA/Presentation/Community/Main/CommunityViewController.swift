//
//  CommunityViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum CommunitySection: Int, CaseIterable {
    case noisy
    case post
    
    var title: String {
        switch self {
        case .noisy:
            return "시끌벅적 게시판 👀"
        case .post:
            return "최신 게시물"
        }
    }
}

final class CommunityViewController: BaseViewController {
    
    @IBOutlet weak var communityTableView: UITableView!
    @IBOutlet weak var writeButton: UIButton!
    
    let communityViewModel = CommunityViewModel()
    
    var dataSource: RxTableViewSectionedReloadDataSource<CommunitySectionModel>!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureDatasource()
        bindViewModel()

        //커뮤니티
        communityViewModel.fetchData()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        //시끌벅적 게시판, 최신게시물 세팅
        communityViewModel.output?.communityData
            .drive(communityTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }
    
    override func bindEvent() {
        
    }
}

extension CommunityViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case CommunitySection.noisy.rawValue:
            return createSectionHeader(CommunitySection.noisy.title)
        case CommunitySection.post.rawValue:
            return createSectionHeader(CommunitySection.post.title)
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case CommunitySection.noisy.rawValue:
            return 240
        case CommunitySection.post.rawValue:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}

extension CommunityViewController {
    private func createSectionHeader(_ title: String) -> UIView? {
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: communityTableView.frame.size.width, height: 36))
        label.font = Fonts.bold_20
        label.text = title
        label.textColor = Colors.text_white
        
        let view = UIView()
        view.addSubview(label)
        view.backgroundColor = .black
        return view
    }
    
    private func configure() {
        communityTableView.delegate = self
        communityTableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        communityTableView.register(UINib(nibName: NoisyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoisyTableViewCell.identifier)
        
        //버튼
        writeButton.layer.cornerRadius = writeButton.frame.size.width / 2
    }
    
    private func configureDatasource() {
        dataSource = RxTableViewSectionedReloadDataSource<CommunitySectionModel>(configureCell: { [unowned self] dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .noisyItem(let data) :
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoisyTableViewCell.identifier, for: indexPath) as? NoisyTableViewCell, let testColors = data.test else { return UITableViewCell() }
                cell.nftCollectionView.dataSource = nil
                
                Observable.just(testColors)
                    .bind(to: cell.nftCollectionView.rx.items(cellIdentifier: NFTCollectionViewCell.identifier, cellType: NFTCollectionViewCell.self)) { item, element, nftCell in
                        nftCell.nftImageView.backgroundColor = testColors[item]
                    }
                    .disposed(by: disposeBag)
                return cell
            case .postItem(let data):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell, let userName = data.userName, let title = data.title, let content = data.content, let cardName = data.cardName, let price = data.price, let commentList = data.commentList else { return UITableViewCell() }
                cell.commentTableView.dataSource = nil
                
                cell.nameLabel.text = userName
                cell.postTitleLabel.text = title
                cell.postBodyLabel.text = content
                cell.nftNameLabel.text = cardName
                cell.priceLabel.text = price
                
                Observable.just(commentList)
                    .bind(to: cell.commentTableView.rx.items(cellIdentifier: CommentTableViewCell.identifier, cellType: CommentTableViewCell.self)) { row, element, commentCell in
                        if row == 2 {
                            commentCell.settingCell(.moreCell, "댓글 모두 보기")
                        } else {
                            commentCell.settingCell(.CommentCell, element.content ?? "")
                        }
                    }
                    .disposed(by: disposeBag)
                return cell
            }
        })
    }
}
