//
//  WeatherLocation.swift
//  MyWeatherApp#2
//
//  Created by Evian on 13.12.2020.
//

import Foundation

struct WeatherLocation: Codable, Equatable {
  var city : String!
  var country : String!
  var countryCode : String!
  var isCurrentLocation : Bool!
}
