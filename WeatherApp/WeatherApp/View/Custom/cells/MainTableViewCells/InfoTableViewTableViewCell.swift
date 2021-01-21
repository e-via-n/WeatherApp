//
//  InfoTableViewTableViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 17.12.2020.
//

import UIKit

class InfoTableViewTableViewCell: UITableViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var infoTableView: UITableView!
  
  //MARK: -Properties
  private var weatherInfoData: [WeatherInfo] = [WeatherInfo]()
  
  //MARK: -Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    infoTableView.register(UINib(nibName: "InfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: String(describing:InfoTableViewCell.self))
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  //MARK: -Setup
  func setColor(stateBackgroundColor: UIColor) {
    backgroundColor = stateBackgroundColor
  }
  
  func setupWeatherInfo(dailyWeather: [DailyWeatherForecast], currentWeather: CurrentWeather ) {
    
    let sunriseInfo = WeatherInfo(infoText: dailyWeather[0].sunrise.time(), nameText: "SUNRISE")
    
    let sunsetInfo = WeatherInfo(infoText: dailyWeather[0].sunset.time(), nameText: "SUNSET")
    
    let windInfo = WeatherInfo(infoText: String(format: "%.1f m/sec", currentWeather.windSpeed), nameText: "WIND")
    
    let humidityInfo = WeatherInfo(infoText: String(format: "%.0f ", currentWeather.humidity), nameText: "HUMIDITY")
    
    let pressureInfo = WeatherInfo(infoText: String(format: "%.0f mb", currentWeather.pressure), nameText: "PRESSURE")
    
    let visibilityInfo = WeatherInfo(infoText: String(format: "%.0f km", currentWeather.visibiliry), nameText: "VISIBILITY")
    
    let feelsLikeInfo = WeatherInfo(infoText: String(format: "%.1f", getTempBasedOnSettings(celsius: currentWeather.feelsLike)), nameText: "FEELS LIKE")
    
    let uvInfo = WeatherInfo(infoText: String(format: "%.1f", currentWeather.uv), nameText: "UV")
    
    weatherInfoData = [ sunsetInfo, sunriseInfo, windInfo, humidityInfo, feelsLikeInfo, pressureInfo, visibilityInfo, uvInfo]
    
    infoTableView.reloadData()
  }
}

//MARK: -TableViewDataSource
extension InfoTableViewTableViewCell: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherInfoData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing:InfoTableViewCell.self), for: indexPath) as! InfoTableViewCell
    cell.setupCell(weatherInfo: weatherInfoData[indexPath .row])
    return cell
  }  
}
