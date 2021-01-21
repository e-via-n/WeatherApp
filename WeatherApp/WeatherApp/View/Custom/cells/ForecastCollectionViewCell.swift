//
//  ForecastCollectionViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var precipitationLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  
  
  //MARK: -Props
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
  }
  
  func generateCell(weather: MainScreenHourlyWeatherModel) {
    setupTimeLabel(time: weather.stringTime)
    weatherIconImageView.image = getWeatherIconFor(weather.icon)
    setupTempLabel(temp: weather.temp)
    setupPrecipitationLabel(precipitation: weather.precipitation)
  }
  
  private func setupPrecipitationLabel(precipitation: Int) {
    if precipitation > 10 {
      precipitationLabel.text = "\(precipitation)%"
    } else {
      precipitationLabel.isHidden = true
    }
  }
  
  private func setupTimeLabel(time: String) {
    if time == "Now" {
      timeLabel.font = .systemFont(ofSize: 17, weight: .bold)
    } else {
      timeLabel.font = .systemFont(ofSize: 17, weight: .medium)
    }
    timeLabel.text = time
  }
  
  private func setupTempLabel(temp: String) {
    if temp == "sunrise" || temp == "sunset" {
      tempLabel.font = .systemFont(ofSize: 17, weight: .semibold)
    } else {
      tempLabel.font = .systemFont(ofSize: 17, weight: .medium)
    }
    tempLabel.text = temp
  }
  
}
