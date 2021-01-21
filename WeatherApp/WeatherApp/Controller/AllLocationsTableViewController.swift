//
//  AllLocationsTableViewController.swift
//  MyWeatherApp#2
//
//  Created by Evian on 13.12.2020.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
  func didChooseLocation(atIndex: Int, shouldUpdate: Bool)
}

enum tempStates {
  case fahrenheit
  case celsius
}

class AllLocationsTableViewController: UITableViewController {
  
  //MARK: -Outlets
  @IBOutlet weak var footerView: UIView!
  @IBOutlet weak var tempSegmentControl: UISegmentedControl!
  
  //MARK: -Properties
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  let userDefaults = UserDefaults.standard
  var weatherData: [CityTempData]?
  var savedLocations: [WeatherLocation]?
  
  var delegate: AllLocationsTableViewControllerDelegate?
  var shouldUpdate = false
  var tempState : tempStates = .celsius
  
  //MARK: -Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = footerView
    
    loadLocationsFromUserDefaults()
    loadTempFormatFromUserDefaults()
  }
  
  deinit {
    self.delegate = nil
  }
  
  //MARK: -Actions
  @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
    updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    tableView.reloadData()
  }
  
  //MARK: -UserDefaults
  private func updateTempFormatInUserDefaults(newValue: Int) {
    shouldUpdate = true
    userDefaults.setValue(newValue, forKey: "TempFormat")
    userDefaults.synchronize()
  }
  
  private func loadTempFormatFromUserDefaults() {
    guard let index = userDefaults.value(forKey: "TempFormat") else { return }
    tempSegmentControl.selectedSegmentIndex = index as! Int
    
    if tempSegmentControl.selectedSegmentIndex == 0 {
      tempState = .celsius
    } else {
      tempState = .fahrenheit
    }
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return weatherData?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
    
    guard weatherData != nil else { return cell }
    
    cell.generateCell(weatherData: weatherData![indexPath.row], tempState: tempState)
    
    return cell
  }
  
  //MARK: -TableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.didChooseLocation(atIndex: indexPath.row, shouldUpdate: shouldUpdate)
    
    self.dismiss(animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (action, view, handler) in
      let locationToDelete = self.weatherData?[indexPath.row]
      
      self.weatherData?.remove(at: indexPath.row)
      
      self.removeLocationFromSavedLocations(location: locationToDelete!.city)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      self.tableView.reloadData()
    }
    
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
    return indexPath.row != 0
  }
  
  //MARK: -Table view editing style
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    if editingStyle == .delete {
      let locationToDelete = weatherData?[indexPath.row]
      weatherData?.remove(at: indexPath.row)
      
      removeLocationFromSavedLocations(location: locationToDelete!.city)
      tableView.reloadData()
    }
  }
  
  private func removeLocationFromSavedLocations(location: String) {
    
    guard savedLocations != nil else { return }
    
    savedLocations?.removeAll(where: {$0.city == location})
    
    //save user defaults
    saveNewLocationToUserDefaults()
    
    return
  }
  
  private func saveNewLocationToUserDefaults() {
    
    shouldUpdate = true
    
    userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
    userDefaults.synchronize()
  }
  
  //MARK: -User defaults
  private func loadLocationsFromUserDefaults() {
    
    if let data = userDefaults.value(forKey: "Locations") as? Data {
      savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
    }
  }
  
  //MARK: -Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "searchLocationSegue" else { return }
    
    let vc = segue.destination as! SearchCityViewController
    vc.delegate = self
  }
}

//MARK: -SearchCityViewControllerDelegate
extension AllLocationsTableViewController: SearchCityViewControllerDelegate {
  
  func didAdd(newLocation: WeatherLocation) {
    shouldUpdate = true
    
    weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
    tableView.reloadData()
  }
}
