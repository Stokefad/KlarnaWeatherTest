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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorPalette.accentColor
        button.setTitleColor(ColorPalette.textColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22)
        // TODO: offscreen rendering
        button.layer.cornerRadius = 16
        button.isUserInteractionEnabled = true
        return button
    }
}
