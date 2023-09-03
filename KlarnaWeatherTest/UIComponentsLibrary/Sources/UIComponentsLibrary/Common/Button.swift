//
//  Button.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 30.08.2023.
//

import UIKit
import Foundation

public final class ButtonFactory {
    public static func regular() -> UIButton {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorPalette.accentColor
        button.setTitleColor(ColorPalette.textColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        button.setBezierPath(cornerRadius: 12)
        button.cornerRadius = 12
        button.isUserInteractionEnabled = true
        return button
    }
}

final class BaseButton: UIButton {
    var cornerRadius: CGFloat?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let cornerRadius {
            setBezierPath(cornerRadius: cornerRadius)
        }
    }
}

public extension UIView {
    func setBezierPath(cornerRadius: CGFloat) {
        let pathWithRadius = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSizeMake(cornerRadius, cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = pathWithRadius.cgPath
        layer.mask = maskLayer
    }
}
