//
//  HomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit
import RxDataSources
import RxSwift
import SkeletonView

// Section
enum HomeSectionType : Hashable {
    case regularSection //stickyHeader 미적용 섹션
    case stickyHeaderSection //stickyHeader 적용 섹션
}

enum HomeSectionItem: Hashable {
    case hotItems([NFTEntity]) //HOT Item
    case hotSellerItems([UserEntity]) // HOT Seller
    case soldOutItems([NFTEntity]) // SOLD Out
    case recentNFTItems([NFTEntity]) // 최신 NFT
    case activityItems([UserEntity]) // 활발한 활동
}

//홈뷰
class HomeViewController: BaseViewController {

    typealias HomeDataSource = UICollectionViewDiffableDataSource<HomeSectionType, HomeSectionItem>
    @IBOutlet weak var mainpageCollectionView: UICollectionView!
    private var dataSource: HomeDataSource? = nil
    //MARK: ViewModel
    let homeViewModel : HomeViewModel = HomeViewModel()
    var isScrolling: Bool = false
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleBar()
        bindViewModel()
        initCollectionView()
        bindEvent()
        mainpageCollectionView.delegate = self
        homeViewModel.input.refreshTrigger.onNext(())
    }

    private func setupTitleBar() {
        let logo = UILabel()
        logo.text = "DIDA"
        logo.font = Fonts.bold_24
        logo.textColor = Colors.text_white
        customTitleBar.leftItems = [logo]
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "bell"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        customTitleBar.rightItems = [rightButton]
    }
    
    @objc func rightButtonTapped() {
        print("Right button in HomeViewController tapped.")
    }

    // 컬렉션뷰 초기화
    func initCollectionView(){
        
        self.mainpageCollectionView.showsVerticalScrollIndicator = false
        configureDataSource()
        self.mainpageCollectionView.dataSource = dataSource
        self.view.isSkeletonable = true
        mainpageCollectionView.collectionViewLayout = createCompositionalLayout()
        mainpageCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        registerNIB()
    }
    
    
    
    override func bindViewModel() {
        
        homeViewModel.output.homeOutput
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                switch result {
                case .success(let homeEntity):
                    if let snapShot = self?.makeSnapshot(homeEntity) {
                        self?.dataSource?.apply(snapShot)
                        self?.mainpageCollectionView.refreshControl?.endRefreshing()
                    }
                case .failure(let error):
                    self?.mainpageCollectionView.refreshControl?.endRefreshing()
                }
            }.disposed(by: disposeBag)
        

        let refreshControl = UIRefreshControl()
        mainpageCollectionView.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: homeViewModel.input.refreshTrigger)
            .disposed(by: disposeBag)

        homeViewModel.showLoading
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] isLoading in
                if isLoading {
                    if let snapShot = self?.makeSnapshot(HomeEntity(getHotItems: [NFTEntity.loading, NFTEntity.loading],
                                                                    getHotSellers: [UserEntity.loading, UserEntity.loading],
                                                                    getRecentCards: [NFTEntity.loading, NFTEntity.loading],
                                                                    getHotUsers: [UserEntity.loading, UserEntity.loading, UserEntity.loading])){
                        self?.dataSource?.apply(snapShot)
                        self?.mainpageCollectionView.reloadData()
                        self?.showLoadingBlocker()
                    }
                    
                }else{
                    if let snapShot = self?.makeSnapshot(HomeEntity(getHotItems: [],
                                                                    getHotSellers: [],
                                                                    getRecentCards: [],
                                                                    getHotUsers: [])){
                        self?.dataSource?.apply(snapShot)
                        self?.mainpageCollectionView.reloadData()
                        self?.hideLoadingBlocker()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        mainpageCollectionView.rx.contentOffset
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
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
                headerView.updateTabBarToIndex(visibleIndexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
}

//MARK: Compositional Layout Setting
extension HomeViewController {

    private func registerNIB(){
        self.mainpageCollectionView.backgroundColor = .black

        mainpageCollectionView.register(UINib(nibName: HotItemSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier)

        mainpageCollectionView.register(TabbarCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TabbarCollectionReusableView.reuseIdentifier)
 
        mainpageCollectionView.register(UINib(nibName: HotSellerSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: HotSellerSectionCollectionViewCell.reuseIdentifier)

        mainpageCollectionView.register(UINib(nibName: SoldOutSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: SoldOutSectionCollectionViewCell.reuseIdentifier)

        mainpageCollectionView.register(UINib(nibName: RecentNFTSectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: RecentNFTSectionCollectionViewCell.reuseIdentifier)

        mainpageCollectionView.register(UINib(nibName: ActivitySectionCollectionViewCell.reuseIdentifier , bundle: nil), forCellWithReuseIdentifier: ActivitySectionCollectionViewCell.reuseIdentifier)
    }
    

    private func makeSnapshot(_ homeEntity: HomeEntity) -> NSDiffableDataSourceSnapshot<HomeSectionType, HomeSectionItem> {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSectionType, HomeSectionItem>()
        snapshot.appendSections([.regularSection, .stickyHeaderSection])
        snapshot.appendItems([.hotItems(homeEntity.getHotItems)], toSection: .regularSection)
        snapshot.appendItems([.hotSellerItems(homeEntity.getHotSellers)], toSection: .stickyHeaderSection)
        snapshot.appendItems([.soldOutItems([])], toSection: .stickyHeaderSection)

        snapshot.appendItems([  .recentNFTItems(homeEntity.getRecentCards)], toSection: .stickyHeaderSection)
        snapshot.appendItems([  .activityItems(homeEntity.getHotUsers)], toSection: .stickyHeaderSection)
        return snapshot
    }

    private func configureDataSource() {

        dataSource = HomeDataSource(collectionView: mainpageCollectionView, cellProvider: { collectionView, indexPath, item in
            //cell 구성
            switch item {
            case .hotItems(let data):
                let cell: HotItemSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! HotItemSectionCollectionViewCell
                cell.hotItems = data
                cell.configureCollectionView()
                return cell

            case .hotSellerItems(let data):
                let cell: HotSellerSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSellerSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! HotSellerSectionCollectionViewCell
                cell.hotSellers = data
                return cell

            case .soldOutItems(let data):
                let cell: SoldOutSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SoldOutSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! SoldOutSectionCollectionViewCell
                cell.configure(items: data)
                return cell

            case .recentNFTItems(let data):
                let cell: RecentNFTSectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentNFTSectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! RecentNFTSectionCollectionViewCell
                cell.configure(items: data)
                return cell

            case .activityItems(let data):
                let cell: ActivitySectionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitySectionCollectionViewCell.reuseIdentifier , for: indexPath)
                as! ActivitySectionCollectionViewCell
                cell.configure(items: data)
                return cell

            }
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TabbarCollectionReusableView.reuseIdentifier, for: indexPath) as! TabbarCollectionReusableView
            header.isSkeletonable = true
            
            header.tabSelectedSubject
                .subscribe(onNext: { [weak self] index in
                    self?.scrollToIndex(index: index)
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            
            
            self?.homeViewModel.showLoading
                .subscribe(onNext: { isLoading in
                    if isLoading {
                        header.configureLoadingView()
                    } else {
                        header.removeLoadingView()
                    }
                })
                .disposed(by: self?.disposeBag ?? DisposeBag())
            
            return header
            
        }
    }
    
    func scrollToIndex(index:Int) {
        guard !isScrolling else { return }
        isScrolling = true
        guard let rect = self.mainpageCollectionView.layoutAttributesForItem(at: IndexPath(row: index, section: 1))?.frame else { return }
        var offset = rect.origin
        offset.y -= self.navigationController?.navigationBar.bounds.height ?? 48
        if mainpageCollectionView.contentOffset == offset {
            isScrolling = false
        } else {
            self.mainpageCollectionView.setContentOffset(offset, animated: true)
        }
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(284))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 36, trailing: 0)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    private func createTabbarSection() -> NSCollectionLayoutSection {
        
        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let groups = createGroupsOfTabbarSection()
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize, subitems: groups)
        group.interItemSpacing = .fixed(42)
        
        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 39, trailing: 0)
        
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous
        
        let header = createHeader()
        
        section.boundarySupplementaryItems = [header]
        return section
        
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.pinToVisibleBounds = true
        return header
    }
    
    private func createGroupsOfTabbarSection() -> [NSCollectionLayoutItem] {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let sellerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(337))
        let sellerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: sellerGroupSize, subitems: [item])
        
        //SOLDOUT 그룹
        let soldoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(489))
        let soldoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: soldoutGroupSize, subitems: [item])
        
        //최신 NFT 그룹
        let recentNFTGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        let recentNFTGroup = NSCollectionLayoutGroup.vertical(layoutSize: recentNFTGroupSize, subitems: [item])
        
        //활발한 활동 그룹
        let activityGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(445))
        let activityGroup = NSCollectionLayoutGroup.vertical(layoutSize: activityGroupSize, subitems: [item])
        let groups = [sellerGroup, soldoutGroup, recentNFTGroup, activityGroup]
        
        
        return groups
    }
}

extension HomeViewController : UICollectionViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == mainpageCollectionView else { return }
        guard !isScrolling else { return }
        updateTabBarForVisibleItem(in: scrollView)
    }
    
    private func updateTabBarForVisibleItem(in scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = mainpageCollectionView.indexPathForItem(at: visiblePoint),
              let headerView = mainpageCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) as? TabbarCollectionReusableView else { return }
        
        headerView.updateTabBarToIndex(indexPath.row)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrolling = false
    }
}
