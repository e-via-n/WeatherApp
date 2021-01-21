//
//  DescriptionTableViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 17.12.2020.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var descriptionLabel: UILabel!
  
  //MARK: -Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.addBorder(edge: .top, color: .white)
    self.layer.addBorder(edge: .bottom, color: .white)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //MARK: -Setup
  func setupDescription(dailyWeather: [DailyWeatherForecast], currentWeather: CurrentWeather ) {
    setTextToLabel(description: currentWeather.weatherState,
                   temp: String(format: "%.0f%@", currentWeather.currentTemp, returnTempFormatFromUserDefaults()),
                   highTemp: String(format: "%.0f%@", dailyWeather[0].highTemp, returnTempFormatFromUserDefaults()))
  }
  
  private func setTextToLabel(description: String, temp: String, highTemp: String) {
    descriptionLabel.text = "Today: \(description) currently, It's \(temp), the hight today was forecast as \(highTemp)"
  }
}
