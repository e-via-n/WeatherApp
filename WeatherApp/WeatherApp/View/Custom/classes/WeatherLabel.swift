//
//  WeatherLabel.swift
//  MyWeatherApp#2
//
//  Created by Evian on 14.01.2021.
//

import UIKit

class WeatherLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    textColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
