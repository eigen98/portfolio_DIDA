//
//  Buttons.swift
//  DIDA-UI
//
//  Created by 김두리 on 2023/02/25.
//

import UIKit
import SnapKit

struct ButtonStateToColor {
    let normal: UIColor?
    let disabled: UIColor?
    let selected: UIColor?
    let hightlight: UIColor?
}

enum ButtonStyle {
    case primary
    case dark
    case dialog
    case custom(ButtonStateToColor)
}

enum ButtonsShape {
    case round
    case suquare
    case circle
}

enum ButtonHeight {
    case h32
    case h36
    case h44
    case h48
    case h52
    case h56
}

class Buttons: UIButton {
    public var defaultColor: UIColor  = Colors.brand_lemon ?? .yellow
    
    public var verticalPadding: CGFloat = 8
    public var horizontalPadding: CGFloat = 15
    
    public var style: ButtonStyle = .dark {
        willSet(newValue) {
            setStyle(newValue)
            self.setNeedsLayout()
        }
    }
    
    public var buttonHeight: ButtonHeight = .h32 {
        willSet(newValue) {
            setHeight(newValue)
            self.setNeedsLayout()
        }
    }
    
    public var shape: ButtonsShape = .suquare {
        willSet(newValue) {
            setShape(newValue)
            self.setNeedsLayout()
        }
    }
    
    var customTitleColor: ButtonStateToColor? {
        willSet(newValue) {
            if let color = newValue {
                setCustomTitleColor(color)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: super.intrinsicContentSize.width + contentEdgeInsets.left + contentEdgeInsets.right + titleEdgeInsets.left + titleEdgeInsets.right, height: super.intrinsicContentSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom + titleEdgeInsets.top + titleEdgeInsets.bottom )
    }
    
    private func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(Colors.background_black, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        
        self.sizeToFit()
    }
    
    private func setHeight(_ height: ButtonHeight) {
        var size: CGSize = self.frame.size
        
        switch height {
        case .h32:
            size.height = 32
        case .h36:
            size.height = 36
        case .h44:
            size.height = 44
        case .h48:
            size.height = 48
        case .h52:
            size.height = 52
        case .h56:
            size.height = 56
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(size.height)
        }
        
        self.sizeToFit()
    }
    
    private func setStyle(_ style: ButtonStyle) {
        switch style {
        case .primary:
            self.setBackgroundImage(UIImage.from(color: Colors.brand_lemon ?? .yellow), for: .normal)
            self.setBackgroundImage(UIImage.from(color: Colors.surface_2 ?? .darkGray), for: .disabled)
            
            self.setTitleColor(Colors.background_black, for: .normal)
            self.setTitleColor(Colors.surface_6, for: .disabled)
            
        case .dark:
            self.setBackgroundImage(UIImage.from(color: Colors.surface_4 ?? .darkGray), for: .normal)
            self.setTitleColor(Colors.text_white, for: .normal)
            
        case .custom(let color):
            setCustomStyle(color)
        case .dialog:
            self.setBackgroundImage(nil, for: .normal)
            self.layer.borderWidth = 1.0
            self.layer.borderColor = Colors.brand_lemon?.cgColor
            self.setTitleColor(Colors.background_black, for: .normal)
        }
    }
    
    private func setCustomStyle(_ color: ButtonStateToColor) {
        self.setBackgroundImage(UIImage.from(color: color.normal ?? defaultColor), for: .normal)
        self.setBackgroundImage(UIImage.from(color: color.disabled ?? defaultColor), for: .disabled)
        self.setBackgroundImage(UIImage.from(color: color.selected ?? defaultColor), for: .selected)
        self.setBackgroundImage(UIImage.from(color: color.hightlight ?? defaultColor), for: .highlighted)
    }
    
    private func setCustomTitleColor(_ color: ButtonStateToColor) {
        self.setTitleColor(color.normal, for: .normal)
        self.setTitleColor(color.disabled, for: .disabled)
        self.setTitleColor(color.selected, for: .selected)
        self.setTitleColor(color.hightlight, for: .highlighted)
    }
    
    private func setShape(_ shape: ButtonsShape) {
        switch shape {
        case .round:
            self.layer.cornerRadius = self.bounds.height/4
            self.clipsToBounds = true
            
            self.titleLabel?.font = Fonts.bold_16
        case .suquare:
            self.titleLabel?.font = Fonts.bold_16
        case .circle:
            self.layer.cornerRadius = self.bounds.height/2
            self.clipsToBounds = true
            self.titleLabel?.font = Fonts.regular_14
        }
    }
}

extension Buttons {
    private func toColorImage(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return image
    }
}
