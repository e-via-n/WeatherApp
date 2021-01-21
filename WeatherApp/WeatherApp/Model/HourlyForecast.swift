//
//  HourlyForecast.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import Foundation
import Alamofire
import SwiftyJSON

class HourlyForecast {
  
  private var _date: Date!
  private var _temp: Double!
  private var _weatherIcon: String!
  private var _precipitation: Int!
  private var _unixTime: Double!
  
  var date: Date {
    guard _date != nil else { _date = Date(); return _date}
    return _date
  }
  
  var temp: Double {
    guard _temp != nil else { _temp = 0.0; return _temp}
    return _temp
  }
  
  var weatherIcon: String {
    guard _weatherIcon != nil else { _weatherIcon = ""; return _weatherIcon}
    return _weatherIcon
  }
  
  var precipitation : Int {
    guard _precipitation != nil else { _precipitation = 0; return _precipitation}
    return _precipitation
  }
  
  var unixTime: Double {
    guard _unixTime != nil else { _unixTime = 0; return _unixTime}
    return _unixTime
  }
  
  
  
  
  init(weatherDictionary: Dictionary<String, AnyObject>) {
    let json = JSON(weatherDictionary)
    
    self._unixTime = json["ts"].double ?? 0.0
    self._temp = getTempBasedOnSettings(celsius: json["temp"].double ?? 0.0)
    self._date = dateFromUnix(unixDate: json["ts"].double!)
    self._weatherIcon = json["weather"]["icon"].stringValue
    self._precipitation = json["pop"].int
  }
  
  
  class func downloadHourlyForecastWeather(_ location: WeatherLocation, completion: @escaping (_ hourlyForecast : [HourlyForecast]) -> Void) {
    
    var url : String!
    
    if !location.isCurrentLocation {
      url = String(format: "https://api.weatherbit.io/v2.0/forecast/hourly?city=%@,%@&key=\(apiKey)&hours=24", location.city, location.countryCode)
    } else {
      url = currentLocationHourlyForecastURL
    }
    url = url.replacingOccurrences(of: " ", with: "_")
    
    
    
    AF.request(url).responseJSON { (response) in
      
      var forecastArray: [HourlyForecast] = []
      
      switch response.result {
      case .success:
        if let dictionary = response.value as? Dictionary<String, AnyObject> {
          if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
            for item in list {
              let forecast = HourlyForecast(weatherDictionary: item)
              forecastArray.append(forecast)
            }
          }
        }
        completion(forecastArray)
      case .failure:
        completion(forecastArray)
      }
    }
  }
}
