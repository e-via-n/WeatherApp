//
//  CurrentWeather.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
  
  private var _city: String!
  private var _date: Date!
  private var _currentTemp: Double!
  private var _feelsLike: Double!
  private var _uv: Double!
  private var _unixTime: Double!
  
  private var _weatherState: String!
  private var _pressure: Double! //mb
  private var _humidity: Double! //%
  private var _windSpeed: Double! //m/sec
  private var _weatherIcon: String!
  private var _visibiliry: Double! //km
  private var _sunrise: String!
  private var _sunset: String!
  
  
  var city: String {
    guard _city != nil else { _city = ""; return _city}
    return _city
  }
  
  var date: Date {
    guard _date != nil else { _date = Date(); return _date}
    return _date
  }
  
  var currentTemp: Double {
    guard _currentTemp != nil else { _currentTemp = 0.0; return _currentTemp}
    return _currentTemp
  }
  
  var feelsLike: Double {
    guard _feelsLike != nil else { _feelsLike = 0.0; return _feelsLike}
    return _feelsLike
  }
  
  var uv: Double {
    guard _uv != nil else { _uv = 0.0; return _uv}
    return _uv
  }
  
  var unixTime: Double {
    guard _unixTime != nil else { _unixTime = 0.0; return _unixTime}
    return _unixTime
  }
  
  var weatherState: String {
    guard _weatherState != nil else { _weatherState = ":("; return _weatherState}
    return _weatherState
  }
  
  var pressure: Double {
    guard _pressure != nil else { _pressure = 0.0; return _pressure}
    return _pressure
  }
  
  var humidity: Double {
    guard _humidity != nil else { _humidity = 0.0; return _humidity}
    return _humidity
  }
  
  var windSpeed: Double {
    guard _windSpeed != nil else { _windSpeed = 0.0; return _windSpeed}
    return _windSpeed
  }
  
  var weatherIcon: String {
    guard _weatherIcon != nil else { _weatherIcon = ""; return _weatherIcon}
    return _weatherIcon
  }
  
  var visibiliry: Double {
    guard _visibiliry != nil else { _visibiliry = 0.0; return _visibiliry}
    return _visibiliry
  }
  
  var sunrise: String {
    guard _sunrise != nil else { _sunrise = ""; return _sunrise}
    return _sunrise
  }
  
  var sunset: String {
    guard _sunset != nil else { _sunset = ""; return _sunset}
    return _sunset
  }
  
  func getCurrentWeather(_ location: WeatherLocation, completion: @escaping (_ success: Bool) -> Void) {
    
    var locationURL : String!
    
    if !location.isCurrentLocation {
      
      locationURL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=\(apiKey)", location.city, location.countryCode)
    } else {
      locationURL = currentLocationURL
    }
    locationURL = locationURL.replacingOccurrences(of: " ", with: "_")
    
    AF.request(locationURL).responseData { response in
      
      switch response.result {
      case .success:
        let json = JSON(response.value as Any)
        
        self._city = json["data"][0]["city_name"].stringValue
        self._date = dateFromUnix(unixDate: json["data"][0]["ts"].double)
        self._weatherState = json["data"][0]["weather"]["description"].stringValue
        
        self._unixTime = json["data"][0]["ts"].double
        self._currentTemp = getTempBasedOnSettings(celsius: json["data"][0]["temp"].double ?? 0.0)
        self._feelsLike = getTempBasedOnSettings(celsius: json["data"][0]["app_temp"].double ?? 0.0)
        self._pressure = json["data"][0]["pres"].double
        self._humidity = json["data"][0]["rh"].double
        self._windSpeed = json["data"][0]["wind_spd"].double
        self._weatherIcon = json["data"][0]["weather"]["icon"].stringValue
        self._visibiliry = json["data"][0]["vis"].double
        self._uv = json["data"][0]["uv"].double
        self._sunrise = json["data"][0]["sunrise"].stringValue
        self._sunset = json["data"][0]["sunset"].stringValue
        
        completion(true)
      case .failure:
        self._city = location.city
        completion(false)
      }
      
    }
  }
  
}
