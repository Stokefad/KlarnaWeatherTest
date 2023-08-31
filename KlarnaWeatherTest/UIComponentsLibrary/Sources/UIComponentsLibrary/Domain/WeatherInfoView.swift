//
//  WeatherInfoView.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import UIKit
import Foundation

public class WeatherInfoView: UIView {
    
    public var temperature: String? {
        didSet {
            temperatureLabel.text = temperature
        }
    }
    
    public var city: String? {
        didSet {
            cityLabel.text = city
        }
    }
    
    private lazy var temperatureLabel = LabelFactory.body()
    
    private lazy var cityLabel = LabelFactory.body()
    
    public init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(temperatureLabel)
        addSubview(cityLabel)
        
        temperatureLabel.topAnchor.constraint(equalTo: topAnchor, constant: Indents.regular).isActive = true
        temperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Indents.regular).isActive = true
        temperatureLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Indents.regular).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: cityLabel.topAnchor, constant: -Indents.regular).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        cityLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: Indents.regular).isActive = true
        cityLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Indents.regular).isActive = true
        cityLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Indents.regular).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
