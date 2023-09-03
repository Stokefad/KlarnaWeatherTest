# KlarnaWeatherTest

Project consists of 3 main packages - BusinessLogic, UIComponentsLibrary and FeatureModules

# Usage

After cloning repo, it's required to add your open weather api key with following code in BusinessLogic.Domain models:

public enum APIKeys {
    public static let openWeatherKey = "your_key"
}

# BusinessLogic

In business logic package there are modules mostly in charge of data providing - networking, location, data base management.

# UIComponentsLibrary

Common: Helper factories for basic components - labels, buttons etc.
Domain: Specific views which could be used in different parts of app

# FeatureModules

2 presentation modules for each of screens. Later this package could be renamed like "WeatherStory" if project will contain different domain.

# Data flow

For current location weather:
1) Taking current location with CoreLocation
2) Requesting geocoder with lat and lon (to get proper location name)
3) Requesting weather with location name

For location search:
1) Requesting geocoder with 0.4 debounce when user typing in searchBar (additionaly one can click "Search")
2) User picks location
3) Steps 2-3 as for current location

# Testing

Most of classes are injected with a protocol, so it's easy to mock service/presenter/viewController in order to test them. 
There are several example tests written for BusinessLogic package

# Dark/light mode support

Asset colors are used for theme support (Color palette for this app is just 3 colors but could be extended easily)

# Forecast react on location change

LocationService calls startMonitoringSignificantLocationChanges(), which callbacks to the same delegate as basic call for current location. If significant location change is detected app will request weather again

# Supporting multiple temperature units

Current temperature unit could be picked with UISegmentedControl and saved with TemperatureUnitPickedService which saves current unit with UserDefaults. After unit change presentation model is being updated in WeatherDomainConverter

















