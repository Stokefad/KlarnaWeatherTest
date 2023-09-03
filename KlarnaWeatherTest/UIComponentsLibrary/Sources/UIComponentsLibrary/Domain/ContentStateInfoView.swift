//
//  File.swift
//  
//
//  Created by Igor Naumenko on 03.09.2023.
//

import UIKit

public final class ContentStateInfoView: UIView {
    public var text: String? {
        didSet {
            infoLabel.text = text
        }
    }
    
    public var isSpinnerVisible = false {
        didSet {
            spinner.isHidden = !isSpinnerVisible
            if isSpinnerVisible {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
    }
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = ColorPalette.textColor
        return spinner
    }()
    
    private lazy var infoLabel = LabelFactory.bodySmall()
    
    public init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setBezierPath(cornerRadius: 16)
    }
    
    private func setupUI() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        addSubview(stackView)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(spinner)
        
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: Indents.regular).isActive = true
        stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Indents.regular).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Indents.regular).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Indents.regular).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        backgroundColor = ColorPalette.backgroundColor
    }
}
