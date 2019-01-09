//
//  WebServices.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-08.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import OHHTTPStubs
import XCGLogger
// URL = "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=f24610eb6630896b3064b1988e2fd4c2"

let API_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATTITUDE = "lat=35"
let LONGITUDE = "&lon=139"
let APP_ID="&appid="
let APP_KEY = "f24610eb6630896b3064b1988e2fd4c2"
let METRIC_UNITS = "&units=metric"

let CURRENT_WEATHER_URL = "\(API_URL)\(LATTITUDE)\(LONGITUDE)\(APP_ID)\(APP_KEY)\(METRIC_UNITS)"

//type alias for the compleation handler that will tell the function when the downloads complete
typealias DownloadComplete = () ->()

final class Webservices{
    
    func downloadCurrentWeather (compleated: DownloadComplete){
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        //saving data as a JSON formated dictionary
        Alamofire.request(currentWeatherURL).responseJSON{ response in
            let result = response.result
            print(CURRENT_WEATHER_URL)
            print(response)
            
        }
        compleated()
    
    }
    
}
