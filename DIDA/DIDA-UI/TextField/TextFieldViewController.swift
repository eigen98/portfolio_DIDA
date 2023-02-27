//
//  TextFieldViewController.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class TextFieldViewController: UIViewController {
    @IBOutlet weak var textfield1: TextField!
    @IBOutlet weak var textfield2: TextField!
    
    let timeLabel = UILabel()
    var interval = 300 // 5분
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField1()
        setTextField2()
    }
    
    func setTextField1() {
        let labelView = UIView()
        labelView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(self.textfield1.frame.height).priority(.low)
        }

        labelView.addSubview(timeLabel)

        timeLabel.font = Fonts.regular_14
        timeLabel.textColor = Colors.text_white

        timeLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }

        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)

        self.textfield1.rightView = labelView
        self.textfield1.rightViewMode = .always
    }
    
    func setTextField2() {
        self.textfield2.placeholder = "댓글을 남겨보세요."
        
        let button = UIButton.init()
        let image = UIImage(named: "comment-send-fill")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        
        let buttonView = UIView()
        buttonView.addSubview(button)
        
        buttonView.snp.makeConstraints { make in
            make.width.equalTo(68)
            make.height.equalTo(self.textfield2.frame.height).priority(.low)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
        
        self.textfield2.rightView = buttonView
        self.textfield2.rightViewMode = .always
    }
    
    @objc func didTapSendButton(_ button: UIButton) {
        print("textfield2 input: \(self.textfield2.text ?? "")")
    }
    
    @objc func changeTime() {
        interval -= 1
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        let formattedString = formatter.string(from: TimeInterval(interval))
        
        self.timeLabel.text = formattedString
        
    }
}
