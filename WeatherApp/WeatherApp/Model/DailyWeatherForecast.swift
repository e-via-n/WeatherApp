//
//  WeeklyWeatherForecast.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class DailyWeatherForecast {
  private var _date: Date!
  private var _highTemp: Double!
  private var _lowTemp: Double!
  private var _weatherIcon: String!
  private var _precipitation: Int!
  private var _sunrise: Double!
  private var _sunset: Double!
  
  var date: Date {
    guard _date != nil else { _date = Date(); return _date}
    return _date
  }
  
  var highTemp: Double {
    guard _highTemp != nil else { _highTemp = 0.0; return _highTemp}
    return _highTemp
  }
  
  var lowTemp: Double {
    guard _lowTemp != nil else { _lowTemp = 0.0; return _lowTemp}
    return _lowTemp
  }
  
  var weatherIcon: String {
    guard _weatherIcon != nil else { _weatherIcon = ""; return _weatherIcon}
    return _weatherIcon
  }
  
  var precipitation: Int {
    guard _precipitation != nil else { _precipitation = 0; return _precipitation}
    return _precipitation
  }
  
  var sunrise: Double {
    guard _sunrise != nil else { _sunrise = 0.0; return _sunrise}
    return _sunrise
  }
  var sunset: Double {
    guard _sunset != nil else { _sunset = 0.0; return _sunset}
    return _sunset
  }
  
  init(weatherDictionary: Dictionary<String, AnyObject>) {
    let json = JSON(weatherDictionary)
    
    self._highTemp = getTempBasedOnSettings(celsius: json["high_temp"].double ?? 0.0)
    self._lowTemp = getTempBasedOnSettings(celsius: json["low_temp"].double ?? 0.0)
    self._date = dateFromUnix(unixDate: json["ts"].double!)
    self._weatherIcon = json["weather"]["icon"].stringValue
    self._precipitation = json["pop"].int
    self._sunrise = json["sunrise_ts"].double
    self._sunset = json["sunset_ts"].double
  }
  
  class func downloadDailyWeather(_ location: WeatherLocation, completion: @escaping (_ weatherForecast: [DailyWeatherForecast]) -> Void) {
    
    var url : String!
    
    if !location.isCurrentLocation {
      url = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&key=\(apiKey)&days=10", location.city, location.countryCode)
    } else {
      url = currentLocationWeeklyForecastURL
    }
    url = url.replacingOccurrences(of: " ", with: "_")
    
    
    AF.request(url).responseJSON { (response) in
      
      var forecastArray: [DailyWeatherForecast] = []
      
      switch response.result {
      
      case .success(_):
        if let dictionary = response.value as? Dictionary<String, AnyObject> {
          if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
            
            for item in list {
              let forecast = DailyWeatherForecast(weatherDictionary: item)
              forecastArray.append(forecast)
            }
          }
        }
        completion(forecastArray)
      case .failure(_):
        completion(forecastArray)
        print("no data for weekly forecast")
      }
      
    }
  }
}
