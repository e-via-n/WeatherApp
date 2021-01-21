//
//  InfoTableViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 15.12.2020.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = .clear
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupCell(weatherInfo: WeatherInfo) {
    nameLabel.text = weatherInfo.nameText
    infoLabel.text = weatherInfo.infoText
  }
  
}
