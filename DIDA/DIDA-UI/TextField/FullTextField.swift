//
//  FullTextField.swift
//  DIDA
//
//  Created by 김두리 on 2023/02/27.
//

import UIKit

class FullTextField: UITextField {
    public var maxLength: Int?
    
    public var insetX: CGFloat = 16
    public var insetY: CGFloat = 18
    
    override var placeholder: String? {
        willSet(newValue) {
            self.attributedPlaceholder = .init(string: newValue ?? "", attributes: [
                NSAttributedString.Key.foregroundColor : Colors.surface_6!
            ])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        self.delegate = self
        
        self.font = Fonts.medium_14
        self.tintColor = Colors.brand_lemon
        self.backgroundColor = Colors.surface_2
        self.layer.borderColor = Colors.surface_5?.cgColor
        self.layer.borderWidth = 1
        self.textColor = Colors.text_white
        
        self.addGestureRecognizer(.init(target: self, action: #selector(didTapTextField(_:))))
        
        let leftView = UIView()
        self.leftView = leftView
        self.leftViewMode = .always
    }
    
    @objc private func didTapTextField(_ sender: Any) {
        self.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, insetX , insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, insetX , insetY)
    }
}

extension FullTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let maxLength = maxLength, let inputString = textField.text {
            let newLength = inputString.count + string.count - range.length
            return newLength <= maxLength
        }
        
        return true
    }
}

