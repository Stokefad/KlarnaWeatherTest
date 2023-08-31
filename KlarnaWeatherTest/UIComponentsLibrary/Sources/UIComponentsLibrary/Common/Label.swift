//
//  Label.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 30.08.2023.
//

import UIKit
import Foundation

public final class LabelFactory {
    public static func bodySmall() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.textColor
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    public static func body() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.textColor
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    public static func title() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorPalette.textColor
        label.font = .systemFont(ofSize: Indents.big)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
}
