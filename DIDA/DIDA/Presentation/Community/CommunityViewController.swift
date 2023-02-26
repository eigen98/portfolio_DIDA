//
//  CommunityViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func bindViewModel() {
    }
    override func bindEvent() {
    }
}

//MARK: - RxDataSource로 바꿔야함.
extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CommunitySection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CommunitySection.noisy.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoisyTableViewCell.identifier, for: indexPath) as? NoisyTableViewCell else { return UITableViewCell() }
            return cell
        case CommunitySection.post.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CommunitySection.noisy.rawValue:
            return 1
        case CommunitySection.post.rawValue:
            return 5
        default:
            return 1
        }
    }
    
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
            return 100
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
        communityTableView.dataSource = self
        
        communityTableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        communityTableView.register(UINib(nibName: NoisyTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: NoisyTableViewCell.identifier)
        
        //버튼
        writeButton.layer.cornerRadius = writeButton.frame.size.width / 2
    }
}
