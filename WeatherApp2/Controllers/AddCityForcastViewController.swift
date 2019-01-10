//
//  AddCityForcastViewController.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit

//AddWeatherDelegate subscribers will get notified
protocol AddWeatherDelegate {
    func addWeatherDidSave (viewModel vm: WeatherViewModel)
}

class AddCityForcastController: UIViewController{
    
    var delegate: AddWeatherDelegate?
    
    let API_URL = "https://api.openweathermap.org/data/2.5/weather?q"
    let APP_ID="&appid="
    let APP_KEY = "f24610eb6630896b3064b1988e2fd4c2"
    let METRIC_UNITS = "&units=metric"
    
    var webServices = Webservices()
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBAction func searchCityButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        print("--------->Click")
        if let city = cityTextField.text{
            print("--------->1")
            let currentWeatherURL = URL(string: "\(API_URL)=\(city)\(APP_ID)\(APP_KEY)\(METRIC_UNITS)")!
            print("--------->2")
            let currentWeatherResoure = CurrentWeatherResource<WeatherViewModel>(url: currentWeatherURL){ data in
                //turning the data into an instance
                let weatherVM = try? JSONDecoder().decode(WeatherViewModel.self, from: data)
                 print("--------->3")
                print("weatherVM= \(weatherVM!)")
                
                return weatherVM
            }
            print("--------->4")
                
            Webservices().downloadCurrentWeather(resource: currentWeatherResoure) { [weak self] result in
                
                if let weatherVM = result {
                    
                    //if unwrap then delegate
                    if let delegate = self?.delegate{
                        delegate.addWeatherDidSave(viewModel: weatherVM)
                        //self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
