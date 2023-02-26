//
//  ProfileViewController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/26.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileView: Profile!
    @IBOutlet weak var borderProfileView: Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfile()
    }
    
    func setProfile() {
        self.profileView.load(urlString: "https://via.placeholder.com/200")
        
        self.borderProfileView.borderColor = Colors.border_line
        self.borderProfileView.load(urlString: "https://via.placeholder.com/200")
    }
}
