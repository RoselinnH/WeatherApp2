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

// URL = "http://api.openweathermap.org/data/2.5/weather?q=Montreal&appid=f24610eb6630896b3064b1988e2fd4c2&units=metric"
// iconURL=http://openweathermap.org/img/w/10d.png


//let CURRENT_WEATHER_URL = "\(API_URL)\(APP_ID)\(APP_KEY)\(METRIC_UNITS)"


struct CurrentWeatherResource<T> {
    let url: URL
    let parse: (Data) -> T?
}

enum NetworkError: Error {
    case invalidResponse, parsingFailure
}

final class Webservices{
    
    static let shared = Webservices()
    
    func downloadWeather(urlStr: String, completion: @escaping ([WeatherViewModel]?, Error?) -> (Void)){
        let url = URL(string: urlStr)
        print("url: ", url!)
        Alamofire.request(url!).responseJSON{ response in
            print("------>inside")
            //response statuses between 200 and 299 indicated success
            if response.response?.statusCode == 200{
                print("------> response satust code == 200")
                switch response.result{
                case .success :
                    print(response.result)
                    if let dict = response.result.value as? Dictionary<String, Any>{
                        print(dict)
                        guard let response = dict["response"] as? Dictionary<String, Any> else{
                            print("-------->response")
                            completion(nil, NetworkError.invalidResponse)
                            return
                        }
                        guard let results = response["results"] as? [Dictionary<String, Any>] else{
                            print("--------->results")
                            completion(nil, NetworkError.parsingFailure)
                            return
                        }
                        print("------------------->response: ",response)
                        print("------------------->results: ",results)
                        //transforming the results
                        let weatherViewModel = results.map({ dict -> WeatherViewModel in
                        
                            return WeatherViewModel(json: dict)!
                        })
                        print(weatherViewModel)
                        completion(weatherViewModel, nil)
                    }
                        

                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
    }
    
//    func downloadCurrentWeather<T> ( resource: CurrentWeatherResource<T>, completed: @escaping (T?) -> Void){
//        //saving data as a JSON formated dictionary
//        Alamofire.request(resource.url).responseJSON{ response in
//            guard response.result.isSuccess else {
//            print("Error while fetching weather")
//
//                return
//            }
//            print(response)
//
//                      //  print(resource.parse)
//
//        }.resume()
//        //not sure about this completion handler
//        //completed(nil)
//    }
    
    
}
}
