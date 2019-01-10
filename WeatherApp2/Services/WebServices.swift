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
// URL = "http://api.openweathermap.org/data/2.5/weather?q=Montreal&appid=f24610eb6630896b3064b1988e2fd4c2&units=metric"
// iconURL=http://openweathermap.org/img/w/10d.png


//let CURRENT_WEATHER_URL = "\(API_URL)\(APP_ID)\(APP_KEY)\(METRIC_UNITS)"


struct CurrentWeatherResource<T> {
    let url: URL
    let parse: (Data) -> T?
}

final class Webservices{
    
    func downloadCurrentWeather<T> ( resource: CurrentWeatherResource<T>, completed: @escaping (T?) -> Void){
        //saving data as a JSON formated dictionary
        Alamofire.request(resource.url).responseJSON{ response in
            guard response.result.isSuccess else {
            print("Error while fetching weather")
                
                return
            }
            print(response)

                      //  print(resource.parse)
            
        }.resume()
        //not sure about this completion handler
        //completed(nil)
    }
    
    
}
