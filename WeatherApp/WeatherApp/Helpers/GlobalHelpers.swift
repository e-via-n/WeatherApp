//
//  GlobalHelpers.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import Foundation
import UIKit

func dateFromUnix(unixDate: Double?) -> Date? {
  if unixDate != nil {
    return Date(timeIntervalSince1970: unixDate!)
  } else {
    return Date()
  }
}

func getWeatherIconFor(_ state: String) -> UIImage? {
  return UIImage(named: state)
}

func fahrenheitFrom(celsius: Double) -> Double{
  return (celsius * 9/5) + 32
}

func celsiusFrom(fahrenheit: Double) -> Double {
  return (fahrenheit - 32) / 1.8
}

func getTempBasedOnSettings(celsius: Double) -> Double {
  let format = returnTempFormatFromUserDefaults()
  
  if format == TempFormat.celsius {
    return celsius
  } else {
    return fahrenheitFrom(celsius: celsius)
  }
}

func setTempBasedOnTempState(temp: Double) -> Double {
  let format = returnTempFormatFromUserDefaults()
  
  if format == TempFormat.fahrenheit {
    return temp
  } else {
    return celsiusFrom(fahrenheit: temp)
  }
}

func returnTempFormatFromUserDefaults() -> String {
  guard let tempFormat = UserDefaults.standard.value(forKey: "TempFormat") else { return TempFormat.celsius}
  guard tempFormat as! Int == 0 else { return TempFormat.fahrenheit}
  return TempFormat.celsius
}

