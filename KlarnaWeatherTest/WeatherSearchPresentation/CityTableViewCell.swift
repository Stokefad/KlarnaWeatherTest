//
//  CityTableViewCell.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 29.08.2023.
//

import UIComponentsLibrary
import UIKit
import Foundation

final class CityTableViewCell: UITableViewCell {
    var name: String? {
        didSet {
            titleLabel.text = name
        }
    }
    
    private lazy var titleLabel = LabelFactory.bodySmall()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Indents.regular).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Indents.regular).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Indents.regular).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Indents.regular).isActive = true
        
        backgroundColor = ColorPalette.backgroundColor
    }
}
