//
//  WeatherSearchPresenter.swift
//  KlarnaWeatherTest
//
//  Created by Igor Naumenko on 27.08.2023.
//

import DomainModels
import GeocoderDataProvider
import SharedModels
import Foundation

protocol IWeatherSearchPresenter: AnyObject {
    func getCities(for text: String)
    func cityWasPicked(at index: Int)
}

final class WeatherSearchPresenter: IWeatherSearchPresenter {
    weak var view: IWeatherSearchViewController?
    weak var output: IWeatherSearchOutputDelegate?
    
    private let geocoderDataProvider: IGeocoderDataProvider
    
    private var cities: [CityDomain] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.foundCities = self.cities.map { CityDomainConverter.convert($0) }
            }
        }
    }
    
    init(geocoderDataProvider: IGeocoderDataProvider) {
        self.geocoderDataProvider = geocoderDataProvider
    }
    
    func getCities(for text: String) {
        geocoderDataProvider.getCities(for: text) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cities):
                self.cities = cities
            case .failure:
                self.cities = []
            }
        }
    }
    
    func cityWasPicked(at index: Int) {
        let city = cities[index]
        output?.cityWasPicked(city: city)
    }
}
