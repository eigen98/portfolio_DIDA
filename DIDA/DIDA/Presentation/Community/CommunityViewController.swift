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
    
    let viewModel = CommunityViewModel()
    var dataSource: RxTableViewSectionedReloadDataSource<CommunitySectionModel>!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureDatasource()
        bindViewModel()

        viewModel.fetchData()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        Observable.combineLatest(viewModel.noisyData, viewModel.postsData)
            .map { (noisyData, postData) -> [CommunitySectionModel] in
                let noisySection = CommunitySectionModel.noisySection(items: noisyData)
                let postSection = CommunitySectionModel.postSection(items: postData)
                return [noisySection, postSection]
            }
            .asDriver(onErrorJustReturn: [])
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
        dataSource = RxTableViewSectionedReloadDataSource<CommunitySectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            switch dataSource[indexPath] {
            case .noisyItem(test: _):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NoisyTableViewCell.identifier, for: indexPath) as? NoisyTableViewCell else { return UITableViewCell() }
                
                return cell
            case .postItem(userName: let userName, title: let title, content: let content, cardName: let cardName, price: let price, commentList: let commentList):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
                
                cell.nameLabel.text = userName
                cell.postTitleLabel.text = title
                cell.postBodyLabel.text = content
                cell.nftNameLabel.text = cardName
                cell.priceLabel.text = price
                
                //MARK: - 이렇게 해도 되는지
                if commentList.count >= 3 {
                    cell.viewModel.fetchComment(Array(commentList[0...2]))
                } else {
                    cell.viewModel.fetchComment(commentList)
                }
                return cell
            }
        })
    }
}
