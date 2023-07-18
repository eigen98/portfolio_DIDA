//
//  ProfileViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/07/15.
//

import UIKit
import RxSwift

class ProfileViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleBar: TitleBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setTitleBar() {
        /*
         let custom1 = UIButton()
         custom1.setImage(UIImage(named: "send-plane-fill"), for: .normal)
         custom1.addTarget(self, action: #selector(tapTitleItem1), for: .touchUpInside)
         */
    }
}
