//
//  TextViewController.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/26.
//

import UIKit

class TextViewController: UIViewController {
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var succesTextView: TextView!
    @IBOutlet weak var errorTextView: TextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextView()
    }
    
    func setTextView() {
        self.textView.placeHolder = "30글자 이하의 한글"
        self.textView.maxLength = 30
        
        self.succesTextView.text = "노아"
        self.succesTextView.statusDelegate?.didChangeSuccessStatus()

        self.errorTextView.text = "노아"
        self.errorTextView.statusDelegate?.didChangeErrorStatus()
    }
}
