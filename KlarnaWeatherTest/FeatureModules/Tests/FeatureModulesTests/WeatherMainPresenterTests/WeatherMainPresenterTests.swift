import XCTest
@testable import WeatherMain

final class WeatherMainPresenterTests: XCTestCase {
    func testPresenterSendsWeatherToViewController() throws {
        let dataProvider = WeatherDataProviderMockWithWeatherData()
        let unitServiceMock = TemperatureUnitServiceMock()
        let presenter = WeatherPresenter(weatherDataProvider: dataProvider, unitPickedService: unitServiceMock)
        let viewController = WeatherMainViewControllerMock(presenter: presenter)
        
        XCTAssertEqual(viewController.weather?.temperature, "233°K")
    }
}
