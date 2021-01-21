//
//  Weather.swift
//  MyWeatherApp#2
//
//  Created by Evian on 24.12.2020.
//

import Foundation

struct MainScreenHourlyWeatherModel {
  var stringTime: String
  let unixTime: Double
  let icon: String
  let temp: String
  let precipitation: Int
}

struct MainScreenCurrentWeatherModel {
  let city: String
  let temperature: String
  let day: String
  let maxTemperature: String
  let minTemperature: String
}


