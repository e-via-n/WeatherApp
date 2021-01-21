//
//  API_URLs.swift
//  MyWeatherApp#2
//
//  Created by Evian on 13.12.2020.
//

import Foundation

//MARK: -Public Weather API URLs
let apiKey = "a2e385feb88c485eba50f6d34fef7e63"

public let currentLocationURL = "https://api.weatherbit.io/v2.0/current?&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=\(apiKey)"

public let currentLocationWeeklyForecastURL = "https://api.weatherbit.io/v2.0/forecast/daily?&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=\(apiKey)&days=10"

public let currentLocationHourlyForecastURL = "https://api.weatherbit.io/v2.0/forecast/hourly?&lat=\(LocationService.shared.latitude!)&lon=\(LocationService.shared.longitude!)&key=\(apiKey)&hours=24"


