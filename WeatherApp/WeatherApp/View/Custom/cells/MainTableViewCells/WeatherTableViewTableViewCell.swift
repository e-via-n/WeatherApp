//
//  WeatherTableViewTableViewCell.swift
//  MyWeatherApp#2
//
//  Created by Evian on 17.12.2020.
//

import UIKit

class WeatherTableViewTableViewCell: UITableViewCell {
  
  //MARK: -Outlets
  @IBOutlet weak var weeklyTableView: UITableView!
  
  //MARK: -Properties
  private var weeklyDataArr: [DailyWeatherForecast] = [DailyWeatherForecast]() {
    didSet {
      weeklyDataArr.remove(at: 0)
      weeklyTableView.reloadData()
    }
  }
  
  //MARK: -Life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    registerCell()
  }
  
  //MARK: -Setup
  func setupCell(data: [DailyWeatherForecast], stateBackgroundColor: UIColor) {
    weeklyDataArr = data
    backgroundColor = stateBackgroundColor
    weeklyTableView.reloadData()
  }
  
  private func registerCell() {
    let nib: UINib = UINib(nibName: String(describing: WeatherTableViewCell.self), bundle: Bundle.main)
    weeklyTableView.register(nib, forCellReuseIdentifier: String(describing:WeatherTableViewCell.self))
  }
}

//MARK: -TableVIew Data Source
extension WeatherTableViewTableViewCell: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weeklyDataArr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherTableViewCell.self), for: indexPath) as! WeatherTableViewCell
    cell.generateCell(forecast: weeklyDataArr[indexPath.row])
    return cell
  }
}
