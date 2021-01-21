//
//  MainWeatherTableViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 13.12.2020.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func generateCell(weatherData: CityTempData, tempState: tempStates) {
    cityLabel.text = weatherData.city
    cityLabel.adjustsFontSizeToFitWidth = true
    
    setupViewCells()
    setupTempLabel(weatherData: weatherData, tempState: tempState)
  }
  
  private func setupTempLabel(weatherData: CityTempData, tempState: tempStates) {
    switch tempState {
    case .celsius:
      tempLabel.text = String(format: "%.0f %@", getTempBasedOnSettings(celsius: weatherData.temp), returnTempFormatFromUserDefaults())
    case .fahrenheit:
      tempLabel.text = String(format: "%.0f %@", setTempBasedOnTempState(temp: weatherData.temp), returnTempFormatFromUserDefaults())
    }
  }
  
  private func setupViewCells() {
    cityLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
    ])
  }
}
