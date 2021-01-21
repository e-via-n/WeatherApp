//
//  Extensions.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import Foundation
import UIKit

extension Date {
  func shortDateFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d"
    return dateFormatter.string(from: self)
  }
  
  func hour() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    return dateFormatter.string(from: self)
  }
  
  func time() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: self)
  }
  
  func dayOfTheWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)
  }
}

extension Double {
  func time() -> String {
    let date = Date(timeIntervalSince1970: self)
    return date.time()
  }
}

extension UIScrollView {
  func scrollToTop() {
    let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
    setContentOffset(desiredOffset, animated: true)
  }
}
