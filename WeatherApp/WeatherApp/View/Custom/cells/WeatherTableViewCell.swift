//
//  WeatherTableViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var precipitationLabel: UILabel!
  @IBOutlet weak var lowTempLabel: UILabel!
  @IBOutlet weak var highTempLabel: UILabel!
  
  //MARK: -Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  //MARK: -Setup
  func generateCell(forecast: DailyWeatherForecast) {
    dayLabel.text = forecast.date.dayOfTheWeek()
    weatherIconImageView.image = getWeatherIconFor(forecast.weatherIcon)
    highTempLabel.text = String(format: "%.0f", forecast.highTemp)
    lowTempLabel.text = String(format: "%.0f", forecast.lowTemp)
    
    precipitationLabelSetup(precipitation: forecast.precipitation)
  }
  
  private func precipitationLabelSetup(precipitation: Int) {
    if precipitation > 30 {
      precipitationLabel.text = "\(precipitation)%"
    } else {
      precipitationLabel.isHidden = true
    }
  }
  
  
}
