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
import Utils

protocol IWeatherSearchPresenter: AnyObject {
    func searchWasPressed(for text: String)
    func cityWasPicked(at index: Int)
    func searchTextWasChanged(text: String)
}

final class WeatherSearchPresenter: IWeatherSearchPresenter {
    weak var view: IWeatherSearchViewController?
    weak var output: IWeatherSearchOutputDelegate?
    
    private let geocoderDataProvider: IGeocoderDataProvider
    private let debouncer: Debouncer
    private let cityDomainConverter: ICityDomainConverter
    
    private var cities: [CityDomain] = [] {
        didSet {
            DispatchQueue.main.async {
                self.view?.foundCities = self.cities.map { self.cityDomainConverter.convert($0) }
            }
        }
    }
    
    init(
        geocoderDataProvider: IGeocoderDataProvider,
        debouncer: Debouncer,
        cityDomainConverter: ICityDomainConverter
    ) {
        self.geocoderDataProvider = geocoderDataProvider
        self.debouncer = debouncer
        self.cityDomainConverter = cityDomainConverter
    }
    
    func searchWasPressed(for text: String) {
        search(text: text)
    }
    
    func searchTextWasChanged(text: String) {
        debouncer.debounce(interval: 0.4) { [weak self] in
            self?.search(text: text)
        }
    }
    
    private func search(text: String) {
        guard !text.isEmpty else {
            cities = []
            return
        }
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
