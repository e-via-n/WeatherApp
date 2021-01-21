//
//  Enum.swift
//  MyWeatherApp#2
//
//  Created by Evian on 26.12.2020.
//

import Foundation
import UIKit


enum BackgroundColorCase: String {
  case night = "night"
  case day = "day"
  case precipitation = "precipitation"
  
  init(value: String) {
    switch value {
    case "night":
      self = .night
    case "day":
      self = .day
    case "precipitation":
      self = .precipitation
    default:
      self = .day
    }
  }
  
  func getColor() -> UIColor {
    switch self {
    case .day:
      return #colorLiteral(red: 0.2399824858, green: 0.5525916815, blue: 0.7396214604, alpha: 1)
    case .night:
      return #colorLiteral(red: 0.05488184839, green: 0.07055146247, blue: 0.1697204709, alpha: 1)
    case .precipitation:
      return #colorLiteral(red: 0.45586133, green: 0.5314458013, blue: 0.5995544791, alpha: 1)
    }
  }
}
