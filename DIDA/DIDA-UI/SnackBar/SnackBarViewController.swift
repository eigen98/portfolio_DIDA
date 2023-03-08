//
//  SnackBarViewController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/28.
//

import UIKit

class SnackBarViewController: UIViewController {
    
    @IBOutlet weak var showSnackBarButton1: UIButton!
    @IBOutlet weak var showSnackBarButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapShowSnackBar1() {
        let snackBar = SnackBar.init(title: "dida 코인이 부족해요", message: "코인을 스왑하고 충전하세요")
        snackBar.addAction(actionItem: .init(title: "확인", isDefault: true, action: {
            snackBar.dismiss()
        }))
        
        snackBar.show()
    }
    
    @IBAction func didTapShowSnackBar2() {
        let imageView = UIImageView.init(image: UIImage(named: "dida-coin-fill"))
        
        let snackBar = SnackBar.init(imageView: imageView, title: "dida 코인이 부족해요", message: "코인을 스왑하고 충전하세요")
        snackBar.addAction(actionItem: .init(title: "취소", isDefault: false, action: {
            snackBar.dismiss()
        }))
        
        snackBar.addAction(actionItem: .init(title: "코인 충전하기", isDefault: true, action: {
            print("tap button:: 코인 충전하기")
        }))
        
        snackBar.show()
    }
}
