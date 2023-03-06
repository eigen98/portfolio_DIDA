//
//  HomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit

// Section
class HomeSection : Hashable {
    let id: String

    init(id: String) {
        self.id = id
    }
    
    static func == (lhs: HomeSection, rhs: HomeSection) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Item
enum HomeSectionItem : Hashable {
    case hotItem
    case stickyTabbar
    case hotSeller
    case recentNFT
    case activity
    
}
//홈뷰
class HomeViewController: BaseViewController {
    
    // 홈에서 사용할 Section과 Item을 명시하여 UICollectionViewDiffableDataSource를 typealias로 생성
    typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem>
    
    @IBOutlet weak var mainpageCollectionView: UICollectionView!
    
    // dataSource
    var dataSource: HomeDataSource? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        
        //initNavigationBar() //네비게이션 바 설정
        
        //initTableView() //tableview 설정
        
        initCollectionView()
    }
    
    /*
     네비게이션 바 뷰 init
     */
    func initNavigationBar(){
        //좌측 DIDA 로고
        let titleLabelView = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 36))
        titleLabelView.numberOfLines = 1
        
        titleLabelView.font = Fonts.bold_24
        titleLabelView.text = "DIDA"
        var titleItem = UIBarButtonItem(customView: titleLabelView)
        titleLabelView.textColor = .white
        self.navigationItem.leftBarButtonItem = titleItem
        
        //우측 알림 버튼
        let alarmButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        alarmButton.setImage(UIImage(named: "bell"), for: .normal)
        alarmButton.addTarget(self, action: #selector(tapAlarmButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    /*
     네비게이션 알람 버튼 클릭 이벤트
     */
    @objc func tapAlarmButton(){
        
    }
    
    // 컬렉션뷰 초기화
    func initCollectionView(){
  
        configureDataSource()
        initSnapshot()
        
        mainpageCollectionView.register(UINib(nibName: HotItemSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier)
        
        mainpageCollectionView.register(UINib(nibName: "HotSellerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HotSellerCollectionViewCell")
        mainpageCollectionView.register(UINib(nibName: "SoldOutCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SoldOutCollectionViewCell")
        mainpageCollectionView.register(UINib(nibName: "RecentNFTCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecentNFTCollectionViewCell")
        mainpageCollectionView.register(UINib(nibName: "ActiveActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActiveActivityCollectionViewCell")
        
        mainpageCollectionView.collectionViewLayout = createCompositionalLayout()
        mainpageCollectionView.reloadData()
        
    }
    // snapshot 생성
    private func initSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>()
        // snapshot에 data 추가
        snapshot.appendSections([HomeSection(id: "")])
        snapshot.appendItems([.hotItem])
        // snapshot 반영
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    // 데이터 소스 초기화
    private func configureDataSource() {
        // dataSource 값 정의
        dataSource = HomeDataSource(collectionView: mainpageCollectionView, cellProvider: { collectionView, indexPath, item in
            //cell 구성
            switch item {
            case .hotItem:
                let cell: HotItemSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotItemSectionCollectionViewCell" , for: indexPath)
                as! HotItemSectionCollectionViewCell
                return cell
                
            default :
                let cell: HotItemSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotItemSectionCollectionViewCell" , for: indexPath)
                as! HotItemSectionCollectionViewCell
                return cell
           
            }
        })
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                return self.createHotItemSection()
//            case 1:
//                return self.createHotSellerSection()
//            case 2:
//                return self.createSoldOutSection()
//            case 3:
//                return self.createRecentNFTSection()
//            case 4:
//                return self.createActiveActivitySection()
            default:
                return self.createHotItemSection()
            }
        }
        return layout
    }
    
    private func createHotItemSection() -> NSCollectionLayoutSection {
        // 아이템이나 그룹의 크기를 정의하는 객체
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)  //각 아이템의 크기를 지정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(284))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        let section = NSCollectionLayoutSection(group: group) // 각 섹션에 포함될 그룹을 지정합니다.
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) //섹션의 콘텐츠를 렌더링할 때 해당 콘텐츠의 인셋(inset)을 지정
        

        section.interGroupSpacing = 20
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

    


}

