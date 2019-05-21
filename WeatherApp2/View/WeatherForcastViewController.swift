//
//  WeatherForcastViewController.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class WeatherForcastViewController: UIViewController {
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var weatherLabel: UILabel!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var table: UITableView!
    @IBOutlet private var icon: UIImageView!
    
    private let cityForcastViewModel = CityForcastViewModel()
    private var tempPerDate: [TemperatureForDate] = []
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(CustomCell.self, forCellReuseIdentifier: "forcstCell")
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = (locations.first?.coordinate.latitude),
            let longitude  = (locations.first?.coordinate.longitude)
            else {return}
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let local = (placemarks?.first?.locality),
                let countryCode = (placemarks?.first?.isoCountryCode)
                else{return}
            let location = local + ", " + countryCode
            self?.fetchForcast(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("🤢 Fail with error \(error.localizedDescription)")
    }
    
    func fetchForcast (location: String) {
        let locationArray = location.components(separatedBy: ",")
        let city = locationArray[0].replacingOccurrences(of: " ", with: "+")
        let countryCode = locationArray[1].replacingOccurrences(of: " ", with: "")
        self.fetchAndRenderForcast(for: city, in: countryCode)
    }
    
     func fetchAndRenderForcast (for city: String, in countryCode: String) {
        self.cityForcastViewModel.getCityForcast(city: city, countryCode: countryCode) { [weak self] in
            guard let iconName = self?.cityForcastViewModel.multiDayForcast?.icon else {return}
            print("🎈Icon \(iconName)")
            let url = URL(string: "http://openweathermap.org/img/w/\(iconName).png")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self?.icon.image = UIImage(data: data!)
                }
            }
            self?.temperatureLabel.text = (self?.cityForcastViewModel.multiDayForcast!.currentTemp ?? "°") + "°"
            self?.weatherLabel.text = self?.cityForcastViewModel.multiDayForcast?.weather
            self?.cityLabel.text = self?.cityForcastViewModel.multiDayForcast?.city
            
            self?.tempPerDate = self?.cityForcastViewModel.multiDayForcast?.temperatureForDates ?? []
            self?.table.reloadData()
        }
    }
    
    @IBAction func addCity(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SelectCity", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? SelectCityController else {return}
        viewController.citySelectedDelegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension WeatherForcastViewController: CitySelectionDelegate {
    func selectedCity(selectedCity: String) {
        self.fetchForcast(location: selectedCity)
        self.navigationController?.popViewController(animated: true)
    }
}

extension WeatherForcastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cityForcastViewModel.dayForcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forcastCell", for: indexPath) as! CustomCell
        cell.setUp(with: self.cityForcastViewModel.dayForcasts[indexPath.row])
        return cell
    }
}

extension WeatherForcastViewController: CLLocationManagerDelegate {}
