//
//  HomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit
import RxDataSources
import RxSwift

// Item
enum HomeSectionType: Hashable {
    case hotItem([HotItemEntity])
    case stickyTabbar
    case hotSeller([HotSellerEntity])
    case soldOut([UserNftEntity])
    case recentNFT([UserNftEntity])
    case activity([HotUserEntity])
    
    var identifier: String {
        switch self {
        case .hotItem:
            return "hotItem"
        case .stickyTabbar:
            return "stickyTabbar"
        case .hotSeller:
            return "hotSeller"
        case .soldOut:
            return "soldOut"
        case .recentNFT:
            return "recentNFT"
        case .activity:
            return "activity"
        }
    }
    
    static func == (lhs: HomeSectionType, rhs: HomeSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.hotItem(let a), .hotItem(let b)):
            return a == b
        case (.stickyTabbar, .stickyTabbar):
            return true
        case (.hotSeller(let a), .hotSeller(let b)):
            return a == b
        case (.soldOut(let a), .soldOut(let b)):
            return a == b
        case (.recentNFT(let a), .recentNFT(let b)):
            return a == b
        case (.activity(let a), .activity(let b)):
            return a == b
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

//홈뷰
class HomeViewController: BaseViewController {
    
    // 홈에서 사용할 Section과 Item을 명시하여 UICollectionViewDiffableDataSource를 typealias로 생성
    typealias HomeDataSource = UICollectionViewDiffableDataSource<Int, HomeSectionType>
    
    @IBOutlet weak var mainpageCollectionView: UICollectionView!
    
    // MARK: dataSource
    var dataSource: HomeDataSource? = nil
    
    //MARK: ViewModel
    let homeViewModel : HomeViewModel = HomeViewModel(dependency: .init(homeRepository: RepositoryProvider.getHomeRepository()))
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        initCollectionView()
        bindEvent()
        mainpageCollectionView.reloadData()
    }
    
    
    // 컬렉션뷰 초기화
    func initCollectionView(){
        
       
        registerNIB()
        
        mainpageCollectionView.collectionViewLayout = createCompositionalLayout()
        
        configureDataSource()
        
        initSnapshot()
        
       
    }
    

  
    override func bindViewModel() {
        mainpageCollectionView.rx.contentOffset
               .compactMap { [weak self] contentOffset -> IndexPath? in
                   guard let self = self else { return nil }
                   let visibleRect = CGRect(origin: contentOffset, size: self.mainpageCollectionView.bounds.size)
                   let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                   return self.mainpageCollectionView.indexPathForItem(at: visiblePoint)
               }
               .filter { $0.section == 1 }
               .distinctUntilChanged()
               .subscribe(onNext: { [weak self] visibleIndexPath in
                   guard let self = self else { return }
                   let headerIndexPath = IndexPath(item: 0, section: 1)
                   guard let headerView = self.mainpageCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath) as? TabbarCollectionReusableView else {
                       return
                   }
                   //headerView.tabbar.tabbarView.selectedSegmentIndex = visibleIndexPath.row
               })
               .disposed(by: disposeBag)
    }
    
}

//MARK: Compositional Layout Setting
extension HomeViewController {
    
    
    private func registerNIB(){
        self.mainpageCollectionView.backgroundColor = .black
       
        //HotItem Cell
        mainpageCollectionView.register(UINib(nibName: HotItemSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier)
        
        //CustomTabbar Cell (Sticky Header)
        mainpageCollectionView.register(TabbarCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TabbarCollectionReusableView.reuseIdentifier)
       
        
        //HotSeller Cell
        mainpageCollectionView.register(UINib(nibName: HotSellerSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotSellerSectionCollectionViewCell.reuseIdentifier)
        
        //Sold Out Cell
        mainpageCollectionView.register(UINib(nibName: SoldOutSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: SoldOutSectionCollectionViewCell.reuseIdentifier)
        
        //최신 NFT Cell
        mainpageCollectionView.register(UINib(nibName: RecentNFTSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: RecentNFTSectionCollectionViewCell.reuseIdentifier)
        
        //활발한 활동 Cell
        mainpageCollectionView.register(UINib(nibName: ActivitySectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: ActivitySectionCollectionViewCell.reuseIdentifier)
    }
    // HomeViewModel의 output 업데이트를 구독 -> 새 스냅샷으로 datasource를 업데이트
    private func initSnapshot() {
        self.mainpageCollectionView.dataSource = dataSource

        if let dataSourceBinder = dataSource?.rx.snapshot() {
            homeViewModel.output.homeOutput
                .map(makeSnapshot)
                .bind(to: dataSourceBinder)
                .disposed(by: disposeBag)
        }
    }

    //전달된 HomeEntity를 기반으로 스냅샷을 생성
    private func makeSnapshot(_ homeEntity: HomeEntity) -> NSDiffableDataSourceSnapshot<Int, HomeSectionType> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, HomeSectionType>()
        // add data to snapshot
        snapshot.appendSections([0, 1])
        snapshot.appendItems([.hotItem(homeEntity.getHotItems)], toSection: 0)
        snapshot.appendItems([.hotSeller(homeEntity.getHotSellers)], toSection: 1)
        snapshot.appendItems([.soldOut([])], toSection: 1)
       
        snapshot.appendItems([  .recentNFT(homeEntity.getRecentCards)], toSection: 1)
        snapshot.appendItems([  .activity(homeEntity.getHotUsers)], toSection: 1)
                            
                            
        return snapshot
    }
    
    // 데이터 소스 초기화
    private func configureDataSource() {
        // dataSource 값 정의
        
        dataSource = HomeDataSource(collectionView: mainpageCollectionView, cellProvider: { collectionView, indexPath, item in
            //cell 구성
            switch item {
            case .hotItem(let data):
                let cell: HotItemSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! HotItemSectionCollectionViewCell
                cell.hotItems = data
                return cell

            case .hotSeller(let data):
                let cell: HotSellerSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSellerSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! HotSellerSectionCollectionViewCell
                cell.hotSellers = data
                return cell
                
            case .soldOut(let data):
                let cell: SoldOutSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SoldOutSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! SoldOutSectionCollectionViewCell
                cell.configure(items: data)
                return cell
                
            case .recentNFT(let data):
                let cell: RecentNFTSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentNFTSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! RecentNFTSectionCollectionViewCell
                cell.configure(items: data)
                return cell
            
            case .activity(let data):
                let cell: ActivitySectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitySectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! ActivitySectionCollectionViewCell
                cell.configure(items: data)
                return cell
            
                
            default :
                
               return UICollectionViewCell()
                
            }
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TabbarCollectionReusableView.reuseIdentifier, for: indexPath) as! TabbarCollectionReusableView
            
            header.setTabBar()
            header.tabSelectedSubject
                .subscribe(onNext: { [weak self] index in
                    self?.scrollToIndex(index: index)
                    header.isClickedTabbar = true
                })
                .disposed(by: self.disposeBag)

            return header
        
        }
    }
    
    func scrollToIndex(index:Int) {
        let rect = self.mainpageCollectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 1))?.frame
        self.mainpageCollectionView.scrollRectToVisible(rect!, animated: true)
    }
    
    
    
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:
                return self.createHotItemSection()
            case 1:
                return self.createTabbarSection()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)  //각 아이템의 크기를 지정
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(284))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        let section = NSCollectionLayoutSection(group: group) // 각 섹션에 포함될 그룹을 지정합니다.
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) //섹션의 콘텐츠를 렌더링할 때 해당 콘텐츠의 인셋(inset)을 지정
 
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    
    //탭바 Section (HotSeller, Soldout, 최신 NFT ,Activity)
    private func createTabbarSection() -> NSCollectionLayoutSection {
 
        // Create an array of groups
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let groups = createGroupsOfTabbarSection()
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: groups)
        
        let section = NSCollectionLayoutSection(group: group)
        
        //섹션의 콘텐츠를 렌더링할 때 해당 콘텐츠의 인셋(inset)을 지정
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        
        section.boundarySupplementaryItems = [header]
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
    private func createGroupsOfTabbarSection() -> [NSCollectionLayoutItem] {
        // 아이템이나 그룹의 크기를 정의하는 객체
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //HOTSeller 그룹
        let sellerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(244)) //244
        let sellerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: sellerGroupSize, subitems: [item]) //그룹의 크기와 그룹 내 아이템의 수를 지정
        
        //SOLDOUT 그룹
        let soldoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(529))
        let soldoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: soldoutGroupSize, subitems: [item])
        
        //최신 NFT 그룹
        let recentNFTGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(740))
        let recentNFTGroup = NSCollectionLayoutGroup.vertical(layoutSize: recentNFTGroupSize, subitems: [item])
        
        //활발한 활동 그룹
        let activityGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(491))
        let activityGroup = NSCollectionLayoutGroup.vertical(layoutSize: activityGroupSize, subitems: [item])
        let groups = [sellerGroup, soldoutGroup, recentNFTGroup, activityGroup]
        
        
        return groups
    }

}
