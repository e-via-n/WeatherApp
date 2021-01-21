//
//  WeatherViewController.swift
//  MyWeatherApp#2
//
//  Created by Evian on 12.12.2020.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {
  
  //MARK: -Outlets
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var toolBar: UIToolbar!
  
  //MARK: -Views
  var allWeatherViews: [MainScreenWeatherViewController] = []
  var loadingView = LoadView()
  
  //MARK: -Properties
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  let userDefaults = UserDefaults.standard
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocationCoordinate2D!
  
  var allLocations : [WeatherLocation] = []
  var allWeatherData: [CityTempData] = []
  
  private var shouldUpdate = false
  private var pageIndex : Int = 0
  
  //MARK: -Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    addLoadingView()
    scrollView.delegate = self
    locationManagerStart()
    setPageControlPageNumber()
  }
  
  override func viewWillLayoutSubviews() {
    toolBarSetup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    locationAuthCheck()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    locationManager.stopUpdatingLocation()
  }
  
  //MARK: -LoadingView
  private func addLoadingView() {
    loadingView = LoadView()
    
    view.addSubview(loadingView.view)
    self.loadingView.view.alpha = 1
    self.loadingView.view.frame = self.view.bounds
  }
  
  private func removeLoadingView(weatherVC: MainScreenWeatherViewController) {
    guard !weatherVC.dailyWeatherForecastData.isEmpty && !weatherVC.hourlyWeatherForecastData.isEmpty else { return }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      UIView.animate(withDuration: 0.7) {
        self.loadingView.view.alpha = 0
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.loadingView.view.removeFromSuperview()
    }
  }
  
  //MARK: -Getting Weather
  private func getWeather() {
    loadLocationsFromUserDefaults()
    createWeatherChildVCs()
    addWeatherToScrollView()
    setPageControlPageNumber()
  }
  
  private func removeChilds() {
    for VC in children {
      VC.willMove(toParent: nil)
      VC.view.removeFromSuperview()
      VC.removeFromParent()
    }
  }
  
  private func createWeatherChildVCs() {
    allWeatherViews = []
    removeChilds()
    
    for _ in allLocations {
      allWeatherViews.append(MainScreenWeatherViewController())
    }
  }
  
  private func generateWeatherList() {
    allWeatherData = []
    
    for weatherView in allWeatherViews {
      allWeatherData.append(CityTempData(city: weatherView.currentWeather.city, temp: weatherView.currentWeather.currentTemp))
    }
    NSLog("Weather data count: \(allWeatherData.count)")
  }
  
  private func addWeatherToScrollView() {
    for i in 0..<allWeatherViews.count {
      print("ALL WEATHER Views\(allWeatherViews.count)")
      
      let weatherVC = allWeatherViews[i]
      let location = allLocations[i]
      
      getCurrentWeather(weatherVC: weatherVC, location: location)
      getDailyWeather(weatherVC: weatherVC, location: location)
      getHourlyWeather(weatherVC: weatherVC, location: location)
      
      let xPos = (self.view.frame.width) * CGFloat(i)
      weatherVC.view.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
      
      addChild(weatherVC)
      scrollView.addSubview(weatherVC.view)
      weatherVC.didMove(toParent: self)
      
      scrollView.contentSize.width = weatherVC.view.frame.width * CGFloat(i + 1)
    }
  }
  
  private func getCurrentWeather(weatherVC: MainScreenWeatherViewController, location: WeatherLocation) {
    
    weatherVC.currentWeather = CurrentWeather()
    weatherVC.currentWeather.getCurrentWeather(location) { (success) in
      weatherVC.updateData()
      self.generateWeatherList()
    }
  }
  
  private func getDailyWeather(weatherVC: MainScreenWeatherViewController, location: WeatherLocation) {
    DailyWeatherForecast.downloadDailyWeather(location) { (weatherForecasts) in
      weatherVC.dailyWeatherForecastData = weatherForecasts
      weatherVC.updateData()
    }
  }
  
  private func getHourlyWeather(weatherVC: MainScreenWeatherViewController, location: WeatherLocation) {
    HourlyForecast.downloadHourlyForecastWeather(location) { (weatherForecasts) in
      weatherVC.hourlyWeatherForecastData = weatherForecasts
      weatherVC.updateData()
      self.removeLoadingView(weatherVC: weatherVC)
    }
  }
  
  //MARK: -Load locations from user defaults
  private func loadLocationsFromUserDefaults() {
    let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
    guard let data = userDefaults.value(forKey: "Locations") as? Data else {NSLog("No data in user defaults");allLocations.append(currentLocation); return}
    
    allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
    allLocations.insert(currentLocation, at: 0)
  }
  
  //MARK: -ToolBar
  private func toolBarSetup() {
    toolBar.layer.addBorder(edge: .top, color: .white)
  }
  
  //MARK: -Page Control
  private func setPageControlPageNumber() {
    pageControl.numberOfPages = allWeatherViews.count
    setupPageConrolIndexImage()
  }
  
  private func setupPageConrolIndexImage() {
    guard pageControl.numberOfPages != 0 else { return }
    let image = UIImage(systemName: "location.fill")
    pageControl.setIndicatorImage(image, forPage: 0)
  }
  
  private func updatePageControlSelectedPage(currentPage: Int) {
    pageControl.currentPage = currentPage
  }
  
  @IBAction func didSelectPage(_ sender: UIPageControl) {
    print(sender.currentPage)
    
    _ = scrollView.frame.size.width * CGFloat(sender.currentPage)
    
    let viewNumber = CGFloat(integerLiteral: sender.currentPage)
    let newOffset = CGPoint(x: (scrollView.frame.width) * viewNumber, y: 0)
    
    scrollView.setContentOffset(newOffset, animated: false)
  }
  
  //MARK: -LocationManager
  private func locationManagerStart() {
    self.locationManager.requestWhenInUseAuthorization()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.showsBackgroundLocationIndicator = true
      locationManager.distanceFilter = 1000
      locationManager.pausesLocationUpdatesAutomatically = true
      locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
      locationManager.startUpdatingLocation()
    }
  }
  
  //MARK: -Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "allLocationsSegue" else { return }
    let vc = segue.destination as! AllLocationsTableViewController
    vc.delegate = self
    
    vc.weatherData = allWeatherData
  }
  
  private func locationAuthCheck() {
    if shouldUpdate {
      allLocations = []
      allWeatherViews = []
      removeChilds()
      getWeather()
      setPage()
    }
  }
  
  private func setPage() {
    let viewNumber = CGFloat(integerLiteral: pageIndex)
    let newOffset = CGPoint(x: scrollView.frame.width * viewNumber , y: 0)
    
    scrollView.setContentOffset(newOffset, animated: true)
    updatePageControlSelectedPage(currentPage: pageIndex)
  }
}

//MARK: -AllLocationsTableViewControllerDelegate
extension WeatherViewController : AllLocationsTableViewControllerDelegate {
  func didChooseLocation(atIndex: Int, shouldUpdate: Bool) {
    if shouldUpdate {
      addLoadingView()
    }
    pageIndex = atIndex
    setPage()
    
    self.shouldUpdate = shouldUpdate
  }
  
  
}

//MARK: -CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to get the location, \(error.localizedDescription)")
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
    if manager.authorizationStatus != .authorizedWhenInUse {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = manager.location?.coordinate
    
    NSLog("Locations: lat=\(currentLocation.latitude), lon=\(currentLocation.longitude)")
    
    LocationService.shared.latitude = currentLocation.latitude
    LocationService.shared.longitude = currentLocation.longitude
    
    getWeather()
    setPageControlPageNumber()
  }
  
}

//MARK: -ScrollView Delegate
extension WeatherViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    NSLog("\(scrollView.contentOffset)")
    
    //updating page control selected page
    let value = scrollView.contentOffset.x / scrollView.frame.size.width
    NSLog("\(value)")
    updatePageControlSelectedPage(currentPage: Int(round(value)))
  }
}

