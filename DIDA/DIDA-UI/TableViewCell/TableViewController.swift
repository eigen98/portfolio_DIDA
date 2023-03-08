//
//  TableViewController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let model: [IconTableCellModel] = [
        IconTableCellModel(icon: UIImage(named: "user-smile-line"), title: "프로필 수정"),
        IconTableCellModel(icon: UIImage(named: "send-plane-line"), title: "임시 비밀번호 발급"),
        IconTableCellModel(icon: UIImage(named: "lock-line"), title: "비밀번호 변경")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.background_black
        
        self.tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}


extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else { return UITableViewCell() }
        
        cell.bind(model[indexPath.row])
        return cell
    }
}
