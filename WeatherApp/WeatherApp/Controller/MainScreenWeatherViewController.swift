//
//  WeatherView.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import UIKit

//MARK: -Constants
fileprivate struct Constants {
  static let offsetHeight: CGFloat = UIScreen.main.bounds.height/3.5
  static let topViewTopOffset: CGFloat = 45
  static let topViewBottomOffset: CGFloat = 103
  static let tableTopConstraint: CGFloat = -137
  static let hourlyViewHeight: CGFloat = 120
  static let scrollViewContentOffset: CGFloat = -62
}

class MainScreenWeatherViewController: UIViewController {
  
  //MARK: -Outlets
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var highTempLabel: UILabel!
  
  @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var tempRangeStackView: UIStackView!
  
  @IBOutlet weak var lowTempLabel: UILabel!
  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var cityNameLabel: UILabel!
  
  @IBOutlet weak var weatherInfoLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  
  //MARK: -Views
  let hourlyVC = HourlyViewController()
  let loadView = LoadView()
  
  //MARK: -Props
  var isTopAnchorConnectedToTableView = false
  
  var currentWeather: CurrentWeather!
  var dailyWeatherForecastData: [DailyWeatherForecast] = []
  var hourlyWeatherForecastData: [HourlyForecast] = []
  
  var stateBackgroundColor: UIColor = .clear {
    didSet {
      view.backgroundColor = stateBackgroundColor
      topView.backgroundColor = stateBackgroundColor
    }
  }
  
  //MARK: -Life Cycle
  override func viewDidLoad() {
    mainSetup()
  }
  
  private func mainSetup() {
    Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
    self.view.addSubview(mainView)
    mainView.frame = self.view.bounds
    mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    addHourlyChildVC()
    setupTableView()
    setupTempAlpha()
  }
  
  //MARK: -Update Data
  public func updateData() {
    guard !dailyWeatherForecastData.isEmpty else { return }
    
    setBackgroundColorToMainScreen(forWeather: currentWeather.weatherState)
    setupCurrentWeather()
    
    mainTableView.reloadData()
  }
  
  //MARK: -Setup Weather
  private func setupCurrentWeather() {
    cityNameLabel.text = currentWeather.city
    weatherInfoLabel.text = currentWeather.weatherState
    tempLabel.text = String(format: "%.0f%@", currentWeather.currentTemp, returnTempFormatFromUserDefaults())
    highTempLabel.text = " \(Int(dailyWeatherForecastData[0].highTemp))°"
    lowTempLabel.text = " \(Int(dailyWeatherForecastData[0].lowTemp))°"
    
  }
  
  //MARK: -Background
  private func setBackgroundColorToMainScreen(forWeather state: String ) {
    var backgroundColorCase : BackgroundColorCase!
    
    let currentTime = Double(NSDate().timeIntervalSince1970)
    if currentTime > dailyWeatherForecastData[0].sunrise && currentTime < dailyWeatherForecastData[0].sunset {
      switch state {
      case "Snow", "Snow shower", "Clouds", "Overcast clouds", "Fog", "Haze", "Smoke", "Mist":
        backgroundColorCase = .precipitation
      default:
        backgroundColorCase = .day
      }
    } else {
      backgroundColorCase = .night
    }
    stateBackgroundColor = backgroundColorCase.getColor()
  }
  
  
  //MARK: -Childs setup
  private func addHourlyChildVC() {
    addChild(hourlyVC)
    hourlyVC.didMove(toParent: self)
  }
  
  //MARK: -TableView Setup
  //convenient method to register cells
  private func registerNib<T: UITableViewCell>(class: T.Type) {
    let heroOneCellNib = UINib(nibName: String(describing: T.self), bundle: Bundle.main)
    self.mainTableView.register(heroOneCellNib, forCellReuseIdentifier: String(describing: T.self))
  }
  
  private func registerCells() {
    self.registerNib(class: WeatherTableViewTableViewCell.self)
    self.registerNib(class: InfoTableViewTableViewCell.self)
    self.registerNib(class: DescriptionTableViewCell.self)
  }
  
  private func setupTableView() {
    mainTableView.dataSource = self
    mainTableView.delegate = self
    mainTableView.contentInset = UIEdgeInsets(top: Constants.offsetHeight, left: 0, bottom: 0, right: 0)
    changeTableViewBounces(to: false)
    
    self.registerCells()
  }
  
  private func setupTempAlpha() {
    tempLabel.alpha = 1
    tempRangeStackView.alpha = 1
  }
  
  private func changeTableViewBounces(to state: Bool) {
    self.mainTableView.bounces = state
    self.mainTableView.alwaysBounceVertical = state
  }
  
}

//MARK: -TableView Data Source
extension MainScreenWeatherViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard !hourlyWeatherForecastData.isEmpty && !dailyWeatherForecastData.isEmpty else { return hourlyVC.view }
    hourlyVC.setupHourlyWeather(currentWeather: currentWeather, dailyWeather: dailyWeatherForecastData, hourlyWeather: hourlyWeatherForecastData)
    
    hourlyVC.setColor(stateBackgroundColor: stateBackgroundColor)
    return hourlyVC.view
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell = UITableViewCell()
    
    guard !dailyWeatherForecastData.isEmpty && !hourlyWeatherForecastData.isEmpty else { return cell }
    
    if indexPath.row == 0 {
      let customCell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewTableViewCell", for: indexPath) as! WeatherTableViewTableViewCell
      customCell.setupCell(data: dailyWeatherForecastData, stateBackgroundColor: stateBackgroundColor)
      cell = customCell
    }
    if indexPath.row == 1 {
      let customCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
      customCell.setupDescription(dailyWeather: dailyWeatherForecastData, currentWeather: currentWeather)
      cell = customCell
    }
    if indexPath.row == 2 {
      let customCell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewTableViewCell", for: indexPath) as! InfoTableViewTableViewCell
      customCell.setupWeatherInfo(dailyWeather: dailyWeatherForecastData, currentWeather: currentWeather)
      customCell.setColor(stateBackgroundColor: stateBackgroundColor)
      cell = customCell
    }
    return cell
  }
}

//MARK: -ScrollViewDelegate
extension MainScreenWeatherViewController: UIScrollViewDelegate {
  
  // culculate alpha depending on the scrollView offset
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let offset = -scrollView.contentOffset.y
    var alpha = 1 * (offset / Constants.offsetHeight)
    var temperatureAplha = alpha
    
    NSLog("OFFSET: \(offset)")
    NSLog("offsetHeight: \(Constants.offsetHeight)")
    // if scrollView has riched the top change topAnchor
    if offset <= 0 {
      stopHourlyWeatherSection()
    } else {
      attachHourlyWeathernToTableView()
      if offset <= Constants.offsetHeight + 1 {
        mainTableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
      }
    }
    if alpha < 1 {
      temperatureAplha -= 0.55
      alpha -= 0.60
    }
    
    let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
    
    if translation.y > 0 {
      if topViewConstraint.constant <= Constants.topViewBottomOffset && topViewConstraint.constant >= (Constants.topViewTopOffset - 1.5) && isTopAnchorConnectedToTableView {
        
        topViewConstraint.constant += 1.5
      }
    }
    if translation.y < 0 {
      if topViewConstraint.constant <= (Constants.topViewBottomOffset + 1.5) && topViewConstraint.constant >= Constants.topViewTopOffset && isTopAnchorConnectedToTableView {
        
        topViewConstraint.constant -= 1.5
      }
    }
    
    if !isTopAnchorConnectedToTableView {
      UIView.animate(withDuration: 0.3, animations: {
        self.topViewConstraint.constant = Constants.topViewTopOffset
        self.topViewConstraint.isActive = true
        self.changeTableViewBounces(to: true)
        self.topView.layoutIfNeeded()
      })
    }
    
    if isTopAnchorConnectedToTableView && topViewConstraint.constant == Constants.topViewTopOffset - 1.5 {
      UIView.animate(withDuration: 0.45) {
        self.changeTableViewBounces(to: false)
      }
    }
    
    topViewConstraint.isActive = true
    tempRangeStackView.alpha = alpha
    tempLabel.alpha = temperatureAplha
  }
  
  //MARK: -ScrollDidEndDragging
  // if user stops scrolling scrollView and doesn't reach the top - scroll to the top
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offset = -scrollView.contentOffset.y
    
    //FIXME: -YES
    if (offset > 0 && offset < (Constants.offsetHeight + Constants.hourlyViewHeight)) && isTopAnchorConnectedToTableView && tempRangeStackView.alpha < 1 {
      UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
        self.tempLabel.alpha = 0
        self.tempRangeStackView.alpha = 0
        
        topViewConstraint.constant = Constants.topViewTopOffset
        topViewConstraint.isActive = true
        scrollView.setContentOffset(CGPoint(x: 0, y: Constants.scrollViewContentOffset), animated: false)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        self.view.layoutIfNeeded()
        
      }) { [unowned self] (isComlited) in
        if isComlited {
          self.isTopAnchorConnectedToTableView = false
          changeTableViewBounces(to: true)
        }
      }
    }
  }
  
  //MARK: -Attaching Hourly Weather
  // attach object to topView
  fileprivate func stopHourlyWeatherSection() {
    if isTopAnchorConnectedToTableView {
      if let tableTopConstraint = tableTopConstraint {
        tableTopConstraint.isActive = false
      }
      self.mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      self.tableTopConstraint = self.mainTableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor,
                                                                        constant: Constants.tableTopConstraint)
      self.tableTopConstraint?.isActive = true
      self.isTopAnchorConnectedToTableView = false
    }
  }
  
  // attach object to tableView back
  fileprivate func attachHourlyWeathernToTableView() {
    if !isTopAnchorConnectedToTableView {
      if let tableTopConstraint = tableTopConstraint {
        tableTopConstraint.isActive = false
      }
      self.tableTopConstraint = self.mainTableView.topAnchor.constraint(equalTo: self.topView
                                                                          .bottomAnchor,
                                                                        constant: Constants.tableTopConstraint)
      self.tableTopConstraint?.isActive = true
      self.mainTableView.contentInset = UIEdgeInsets(top: Constants.offsetHeight + 1, left: 0, bottom: 0, right: 0)
      self.isTopAnchorConnectedToTableView = true
    }
  }
}
