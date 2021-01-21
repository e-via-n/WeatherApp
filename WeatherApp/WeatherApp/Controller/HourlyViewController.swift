//
//  HourlyViewController.swift
//  MyWeatherApp#2
//
//  Created by Evian on 27.12.2020.
//

import UIKit

private enum Constants {
  static let spacing: CGFloat = 17
}

class HourlyViewController: UIViewController {
  
  //MARK: -Outlets
  @IBOutlet var hourlyView: UIView!
  @IBOutlet weak var hourlyCollectionView: UICollectionView!
  
  //MARK: -Props
  var hourlyForecastArr : [MainScreenHourlyWeatherModel] = []
  
  //MARK: -Life cycle
  override func viewWillAppear(_ animated: Bool) {
    self.view.layer.addBorder(edge: .top, color: .white)
    self.view.layer.addBorder(edge: .bottom, color: .white)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main)
    hourlyCollectionView.register(nib, forCellWithReuseIdentifier: "ForecastCollectionViewCell")
  }
  
  //MARK: -Setup
  func setupHourlyWeather(currentWeather: CurrentWeather, dailyWeather: [DailyWeatherForecast], hourlyWeather: [HourlyForecast]) {
    
    setupHourlyData(currentWeather: currentWeather, dailyWeather: dailyWeather, hourlyWeather: hourlyWeather)
    
    hourlyCollectionView.reloadData()
  }
  
  func setColor(stateBackgroundColor: UIColor) {
    view.backgroundColor = stateBackgroundColor
  }
  
  private func setupHourlyData(currentWeather: CurrentWeather, dailyWeather: [DailyWeatherForecast], hourlyWeather: [HourlyForecast])  {
    
    var mainScreenHourlyWeather : [MainScreenHourlyWeatherModel] = []
    guard currentWeather.city != "" else { return }
    
    var sunrise: Double!
    var sunset: Double!
    
    let currentTime = Double(NSDate().timeIntervalSince1970)
    
    if dailyWeather[0].sunrise > currentTime {
      sunrise = dailyWeather[0].sunrise
    } else {
      sunrise = dailyWeather[1].sunrise
    }
    if dailyWeather[0].sunset > currentTime {
      sunset = dailyWeather[0].sunset
    } else {
      sunset = dailyWeather[1].sunset
    }
    
    for weather in hourlyWeather {
      let stringTime = weather.date.hour()
      let unixTime = weather.unixTime
      let icon = weather.weatherIcon
      let temp = String(format: " %.0f°", weather.temp)
      let precipitation = weather.precipitation
      
      let mainScreenHourlyWeatherModel = MainScreenHourlyWeatherModel(stringTime: stringTime,
                                                                      unixTime: unixTime,
                                                                      icon: icon,
                                                                      temp: temp,
                                                                      precipitation: precipitation)
      
      mainScreenHourlyWeather.append(mainScreenHourlyWeatherModel)
    }
    
    let currentTimeHourlyWeather = MainScreenHourlyWeatherModel(stringTime: currentWeather.date.hour(), unixTime: currentTime, icon: currentWeather.weatherIcon, temp: String(format: " %.0f°", currentWeather.currentTemp), precipitation: 0)
    
    let sunriseTimeHourlyWeather = MainScreenHourlyWeatherModel(stringTime: sunrise.time(),
                                                                unixTime: sunrise,
                                                                icon: "sunrise",
                                                                temp: "sunrise",
                                                                precipitation: 0)
    
    let sunsetTimeHourlyWeather = MainScreenHourlyWeatherModel(stringTime: sunset.time(),
                                                               unixTime: sunset,
                                                               icon: "sunset",
                                                               temp: "sunset",
                                                               precipitation: 0)
    mainScreenHourlyWeather.append(sunriseTimeHourlyWeather)
    mainScreenHourlyWeather.append(sunsetTimeHourlyWeather)
    mainScreenHourlyWeather.append(currentTimeHourlyWeather)
    
    
    mainScreenHourlyWeather.sort { (one, two) -> Bool in
      return one.unixTime < two.unixTime
    }
    
    mainScreenHourlyWeather[0].stringTime = "Now"
    
    hourlyForecastArr = mainScreenHourlyWeather
  }
}

//MARK: -CollectionView Data Source
extension HourlyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    hourlyForecastArr.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCollectionViewCell", for: indexPath) as! ForecastCollectionViewCell
    
    cell.generateCell(weather: hourlyForecastArr[indexPath .row])
    return cell
  }
}

extension HourlyViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let item = hourlyForecastArr[indexPath .row]
    let itemSize = item.temp.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
    
    return CGSize(width: itemSize.width + Constants.spacing, height: 120)
  }
}
