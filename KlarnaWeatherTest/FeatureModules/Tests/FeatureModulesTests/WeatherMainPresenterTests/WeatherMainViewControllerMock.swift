//
//  File.swift
//  
//
//  Created by Igor Naumenko on 02.09.2023.
//

import Foundation
@testable import WeatherMain
import UIKit

final class WeatherMainViewControllerMock: UIViewController, IWeatherViewController {
    var weather: Weather?
    
    private let presenter: IWeatherPresenter
    
    var errorTitle: String?
    
    init(presenter: IWeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(errorTitle: String, errorText: String) {
        self.errorTitle = errorTitle
    }
}
