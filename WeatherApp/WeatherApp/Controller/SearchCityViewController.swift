//
//  SearchCityViewController.swift
//  MyWeatherApp#2
//
//  Created by Evian on 13.12.2020.
//

import UIKit

protocol SearchCityViewControllerDelegate {
  func didAdd(newLocation: WeatherLocation)
}

class SearchCityViewController: UIViewController {
  
  //MARK: -Outlets
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: -Props
  var allLocations:[WeatherLocation] = []
  var filteredLocations: [WeatherLocation] = []
  
  let searchController = UISearchController(searchResultsController: nil)
  
  let userDefaults = UserDefaults.standard
  var savedLocations: [WeatherLocation]?
  
  var delegate: SearchCityViewControllerDelegate?
  
  //MARK: -Life Cycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    loadFromUserDefaults()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchController()
    tableView.tableHeaderView = searchController.searchBar
    tableView.tableHeaderView?.backgroundColor = .white
    
    loadLocationsFromCSV()
  }
  
  //MARK: -Setup
  private func setupTapGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
    self.tableView.backgroundView = UIView()
    self.tableView.backgroundView?.addGestureRecognizer(tap)
  }
  
  @objc private func tableTapped() {
    dismissView()
  }
  
  private func setupSearchController() {
    searchController.searchBar.placeholder = "City or Country"
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    definesPresentationContext = true
    
    searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
    searchController.searchBar.sizeToFit()
    searchController.searchBar.backgroundImage = UIImage()
  }
  
  //MARK: -Get locations
  private func loadLocationsFromCSV() {
    if let path = Bundle.main.path(forResource: "location", ofType: "csv") {
      parseCSVAt(url: URL(fileURLWithPath: path))
    }
  }
  
  private func parseCSVAt(url: URL) {
    do {
      let data = try Data(contentsOf: url)
      let dataEncoded = String(data: data, encoding: .utf8)
      
      var i = 0
      
      if let dataArr = dataEncoded?.components(separatedBy: "\n").map({ $0.components(separatedBy: ",")}) {
        
        for line in dataArr {
          if line.count > 2 && i != 0 {
            createLocation(line: line)
          }
          i += 1
        }
      }
    } catch {
      print("Error reading SCV file", error.localizedDescription)
    }
  }
  
  private func createLocation(line : [String]) {
    allLocations.append(WeatherLocation(city: line[1], country: line[4], countryCode: line[3], isCurrentLocation: false))
  }
  
  //MARK: -User Defaults
  private func saveToUserDefaults(location: WeatherLocation) {
    
    if savedLocations != nil {
      if !savedLocations!.contains(location) {
        savedLocations!.append(location)
      }
    } else {
      savedLocations = [location]
    }
    userDefaults.set( try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
    userDefaults.synchronize()
  }
  
  private func loadFromUserDefaults() {
    
    if let data = userDefaults.value(forKey: "Locations") as? Data {
      savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
    }
  }
  
  private func dismissView() {
    
    if searchController.isActive {
      searchController.dismiss(animated: true) {
        self.dismiss(animated: true)
      }
    } else {
      self.dismiss(animated: true)
    }
  }
}

//MARK: -SearchResultsUpdating
extension SearchCityViewController: UISearchResultsUpdating {
  
  func filterContentForSearchText(searchText: String, scope: String = "All") {
    print("Searching for \(searchText)")
    filteredLocations = allLocations.filter({(location) -> Bool in
      return location.city.lowercased().contains(searchText.lowercased()) || location.country.lowercased().contains(searchText.lowercased())
    })
    tableView.reloadData()
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchText: searchController.searchBar.text!)
  }
}

//MARK: -Table view data source
extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredLocations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    let location = filteredLocations[indexPath .row]
    
    cell.textLabel?.text = location.city
    cell.detailTextLabel?.text = location.country
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    NSLog("City: \(filteredLocations[indexPath .row])")
    
    saveToUserDefaults(location: filteredLocations[indexPath.row])
    delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
    dismissView()
  }
}
