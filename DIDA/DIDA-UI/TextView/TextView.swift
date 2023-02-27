//
//  TextView.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/26.
//

import UIKit

protocol TextViewDelegate: AnyObject {
    func didChangeSuccessStatus()
    func didChangeErrorStatus()
}

protocol TextViewInterface {
    var maxLength: Int? { get set }
    var placeHolder: String? { get set }
}

class TextView: UITextView, TextViewInterface {
    var maxLength: Int?
    
    var placeHolder: String? {
        willSet(newVal) {
            self.text = newVal
            self.textColor = newVal == nil ? Colors.text_white : Colors.surface_6
        }
    }
    
    weak var statusDelegate: TextViewDelegate?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.statusDelegate = self
        self.delegate = self
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.font = Fonts.medium_14
        self.tintColor = Colors.brand_lemon
        self.backgroundColor = Colors.surface_2
        self.layer.borderColor = Colors.surface_5?.cgColor
        self.layer.borderWidth = 1
        self.textContainerInset = .init(top: 18, left: 16, bottom: 18, right: 16)
        self.textColor = self.placeHolder == nil ? Colors.text_white : Colors.surface_6
        
        self.addGestureRecognizer(.init(target: self, action: #selector(didTapTextView(_:))))
        
        self.setNeedsLayout()
    }
    
    @objc private func didTapTextView(_ sender: Any) {
        self.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
}

extension TextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeHolder {
            textView.text = nil
            textView.textColor = Colors.text_white
        } else {
            textView.textColor = Colors.text_white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = self.placeHolder
            textView.textColor = Colors.surface_6
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let textString = textView.text, let newRange = Range(range, in: textString) else { return true }
        
        let newString = textString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        if let maxLength = maxLength {
            return newString.count <= maxLength
        }
        
        return true
    }
}


extension TextView: TextViewDelegate {
    func didChangeSuccessStatus() {
        let successImage = UIImage(named: "Check")?.withTintColor(Colors.text_notice_green ?? .green)
        let imageView = UIImageView.init(image: successImage)
        imageView.frame = .init(x: self.frame.width-16-24, y: 15, width: 24, height: 24)
        self.addSubview(imageView)
        self.textContainerInset = .init(top: 18, left: 16, bottom: 18, right: 44)
    }
    
    func didChangeErrorStatus() {
        let successImage = UIImage(named: "close")?.withTintColor(Colors.text_notice_red ?? .red)
        let imageView = UIImageView.init(image: successImage)
        imageView.frame = .init(x: self.frame.width-16-24, y: 15, width: 24, height: 24)
        self.addSubview(imageView)
        self.textContainerInset = .init(top: 18, left: 16, bottom: 18, right: 44)
    }
}
