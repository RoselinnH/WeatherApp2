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
    
    var webServices = Webservices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webServices.downloadCurrentWeather {
            
        }
    }
}
    
    

