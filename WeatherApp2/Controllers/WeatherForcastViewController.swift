//
//  WeatherForcastViewController.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit



class WeatherForcastViewController: UIViewController{
    let API_URL="http://openweathermap.org/img/w/"
    var webServices = Webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    func addWeatherDidSave(viewModel vm: WeatherViewModel) {
//        print("I'm in")
//        print(vm.name)
//        print(vm.main.temp)
//    }
    
    //This code will run in the Navigation Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController else{
            fatalError("NavicationControler is not found")
        }
        guard let addCityForcastVC = navigation.viewControllers.first as? AddCityForcastController else{
            fatalError("AddCityForcastController not found")
        }
        
       
        
    }
}
    
    

