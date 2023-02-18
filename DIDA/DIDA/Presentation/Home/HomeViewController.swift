//
//  HomeViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/18.
//

import UIKit
//홈뷰
class HomeViewController: BaseViewController {
    
    @IBOutlet weak var mainpageTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
        
        initNavigationBar() //네비게이션 바 설정
        
        initTableView() //tableview 설정
        
    }
    
    /*
     네비게이션 바 뷰 init
     */
    func initNavigationBar(){
        //좌측 DIDA 로고
        let titleLabelView = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 36))
        titleLabelView.numberOfLines = 1
        
        titleLabelView.font = .systemFont(ofSize: 24, weight: .bold)
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
    
    /*
     테이블 뷰 init
     */
    func initTableView(){
        mainpageTableView.delegate = self
        mainpageTableView.dataSource = self
        
        mainpageTableView.register(UINib(nibName: "HotItemTableViewCell", bundle: nil), forCellReuseIdentifier: "HotItemTableViewCell") //Hot Item
        mainpageTableView.register(UINib(nibName: "SoldOutTableViewCell", bundle: nil), forCellReuseIdentifier: "SoldOutTableViewCell") //Sold Out
        mainpageTableView.register(UINib(nibName: "RecentNFTTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentNFTTableViewCell") //최신 NFT
        
        mainpageTableView.reloadData()
    }
    
    


}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row{
        case 0 :
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotItemTableViewCell", for: indexPath) as! HotItemTableViewCell
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SoldOutTableViewCell", for: indexPath) as! SoldOutTableViewCell
            return cell
            
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HotItemTableViewCell", for: indexPath) as! HotItemTableViewCell
            return cell
            
        }
       
    }
    
    
}
