//
//  HomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit
import RxDataSources


// Item
enum HomeSectionItem : Hashable {
    case hotItem
    case stickyTabbar
    case hotSeller
    case soldOut
    case recentNFT
    case activity
    
}
//홈뷰
class HomeViewController: BaseViewController {
    
    // 홈에서 사용할 Section과 Item을 명시하여 UICollectionViewDiffableDataSource를 typealias로 생성
    typealias HomeDataSource = UICollectionViewDiffableDataSource<Int, HomeSectionItem>
    
    @IBOutlet weak var mainpageCollectionView: UICollectionView!
    
    // dataSource
    var dataSource: HomeDataSource? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        navigationController?.isNavigationBarHidden = false
        
        //initNavigationBar() //네비게이션 바 설정
        
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
        
        self.mainpageCollectionView.backgroundColor = .black
        // mainpageCollectionView 등록
        configureDataSource()
        initSnapshot()
       
        //HotItem Cell
        mainpageCollectionView.register(UINib(nibName: HotItemSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier)
        
        //CustomTabbar Cell (Sticky Header)
        mainpageCollectionView.register(TabbarSectionCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TabbarSectionCollectionViewCell.reuseIdentifier)
       
        //HotSeller Cell
        mainpageCollectionView.register(UINib(nibName: HotSellerSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotSellerSectionCollectionViewCell.reuseIdentifier)
        
        //Sold Out Cell
        mainpageCollectionView.register(UINib(nibName: SoldOutSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: SoldOutSectionCollectionViewCell.reuseIdentifier)
        
        //최신 NFT Cell
        mainpageCollectionView.register(UINib(nibName: RecentNFTSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: RecentNFTSectionCollectionViewCell.reuseIdentifier)
        
        //활발한 활동 Cell
        mainpageCollectionView.register(UINib(nibName: ActivitySectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: ActivitySectionCollectionViewCell.reuseIdentifier)
        
        mainpageCollectionView.collectionViewLayout = createCompositionalLayout()
        mainpageCollectionView.reloadData()
        
    }
    // snapshot 생성
    private func initSnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<Int, HomeSectionItem>()
        // snapshot에 data 추가
        snapshot.appendSections([0,1])
        snapshot.appendItems([.hotItem],toSection: 0)
        snapshot.appendItems([.hotSeller, .soldOut, .recentNFT, .activity],toSection: 1)
        
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
                let cell: HotItemSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! HotItemSectionCollectionViewCell
                return cell

            case .hotSeller:
                let cell: HotSellerSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSellerSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! HotSellerSectionCollectionViewCell
                return cell
                
            case .soldOut:
                let cell: SoldOutSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SoldOutSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! SoldOutSectionCollectionViewCell
                return cell
                
            case .recentNFT:
                let cell: RecentNFTSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentNFTSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! RecentNFTSectionCollectionViewCell
                return cell
            
            case .activity:
                let cell: ActivitySectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitySectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! ActivitySectionCollectionViewCell
                return cell
            
                
            default :
                let cell: TabbarSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabbarSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! TabbarSectionCollectionViewCell
                return cell
           
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TabbarSectionCollectionViewCell.reuseIdentifier, for: indexPath) as! TabbarSectionCollectionViewCell
                    header.backgroundColor = .yellow // TODO: 커스텀 탭바 완료 후 적용
    
                    return header
                } else {
                    return nil
                }
            }
    }
    
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                return self.createHotItemSection()
            case 1:
                return self.createHotSellerSection()
  
            default:
                return self.createHotItemSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
            config.interSectionSpacing = 0
            layout.configuration = config
        return layout
    }
    //Hot Item Section
    private func createHotItemSection() -> NSCollectionLayoutSection {
        // 아이템이나 그룹의 크기를 정의하는 객체
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)  //각 아이템의 크기를 지정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(284))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        let section = NSCollectionLayoutSection(group: group) // 각 섹션에 포함될 그룹을 지정합니다.
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) //섹션의 콘텐츠를 렌더링할 때 해당 콘텐츠의 인셋(inset)을 지정
 
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    
    //탭바 Section
    private func createHotSellerSection() -> NSCollectionLayoutSection {
 
        // Create an array of groups
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(3.0))
        let groups = createGroupsOfTabbarSection()
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: groups)
       
        let section = NSCollectionLayoutSection(group: group)
        //섹션의 콘텐츠를 렌더링할 때 해당 콘텐츠의 인셋(inset)을 지정
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        
        var header = createHeader()
        
        section.boundarySupplementaryItems = [header]
        
        //섹션의 콘텐츠를 렌더링할 때 해당 콘텐츠의 인셋(inset)을 지정
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        return section
        
    }
    
    /*
     Sticky Header 설정
     */
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        // Sticky Header View 설정
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true // Sticky Header View 설정
        return header
    }
    
    /*
     탭바 섹션의 각 그룹 생성
     */
    private func createGroupsOfTabbarSection() -> [NSCollectionLayoutGroup] {
        // 아이템이나 그룹의 크기를 정의하는 객체
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //HOTSeller 그룹
        let sellerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(244)) //244
        let sellerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: sellerGroupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        
        //SOLDOUT 그룹
        let soldoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(529))
        let soldoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: soldoutGroupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        
        //최신 NFT 그룹
        let recentNFTGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(740))
        let recentNFTGroup = NSCollectionLayoutGroup.vertical(layoutSize: recentNFTGroupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        
        //활발한 활동 그룹
        let activityGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(491))
        let activityGroup = NSCollectionLayoutGroup.vertical(layoutSize: activityGroupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        let groups = [sellerGroup, soldoutGroup, recentNFTGroup, activityGroup]
        
        return groups
    }
    
    

}

