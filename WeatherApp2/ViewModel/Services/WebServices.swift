//
//  WebServices.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-08.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import Alamofire

struct CurrentWeatherResource<T> {
    let url: URL
    let parse: (Data) -> T?
}

enum WebService: Error {
    case malformedURL
    case invalidResponse
    case parsingFailure
}

final class Webservices{
    let apiURL = "http://api.openweathermap.org/data/2.5/forecast?q="
    let appID="&appid="
    let appKey = "f24610eb6630896b3064b1988e2fd4c2"
    let metricUnits = "&units=metric"
    let decoder = JSONDecoder()
    
    func downloadWeather(city: String, countryCode: String, then: @escaping (Forcast?, Error?)-> Void) {

        let weatherForcastURL = "\(apiURL)\(city),\(countryCode)\(appID)\(appKey)\(metricUnits)".folding(options: .diacriticInsensitive, locale: .current)
        //example: folding Montréal to Montreal
        guard let url = URL(string: weatherForcastURL) else {
            then(nil, WebService.malformedURL)
            return
        }
        print("Calling url: ", url)
        Alamofire.request(url).responseJSON{ response in
                switch response.result {
                case .success:
                    guard
                        let data = response.data,
                        let forecast = try? self.decoder.decode(Forcast.self, from: data)
                        else {
                            then(nil, WebService.parsingFailure)
                            return
                    }
                    then(forecast, nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    then(nil, error)
                }
        }
    }
    
}

