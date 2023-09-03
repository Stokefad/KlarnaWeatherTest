import XCTest
@testable import WeatherMain
@testable import SharedModels

final class WeatherMainPresenterTests: XCTestCase {
    func testPresenterSendsWeatherToViewController() throws {
        let dataProvider = WeatherDataProviderMockWithWeatherData()
        let unitServiceMock = TemperatureUnitServiceMock()
        let presenter = WeatherPresenter(
            weatherDataProvider: dataProvider,
            unitPickedService: unitServiceMock,
            weatherDomainConverter: WeatherDomainConverter(cityDomainConverter: CityDomainConverter()),
            errorConverter: ErrorConverter(),
            temperatureUnitConverter: TemperatureUnitConverter()
        )
        let viewController = WeatherMainViewControllerMock(presenter: presenter)
        
        XCTAssertEqual(viewController.weather?.temperature, "233°K")
    }
}
