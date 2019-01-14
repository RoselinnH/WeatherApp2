//
//  WeatherForecastViewModel.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-09.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation



struct WeatherViewModel {
    
    var temp: String?
    var temp_max: String?
    var temp_min: String?
    
//    //it is being returned meaning no key
//    let name: String //city
//
//    //main
//    let main: TempViewModel
//    let weather: IconViewModel
//    let sys: CountryViewModel
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case main = "main"
//        case weather = "weather"
//        case sys = "sys"
//    }

}

extension WeatherViewModel{
    init?(json: Dictionary<String, Any>){
        guard let dict = json as? Dictionary<String, Any> else{
            return nil
        }
        let temp = dict["temp"] as! String
        let temp_max = dict["temp_max"] as! String
        let temp_min = dict["temp_min"] as! String
        
        self.init(temp: temp, temp_max: temp_max, temp_min: temp_min)
    }
}

struct IconViewModel: Decodable {
    //weather
    let icon: String
}

struct CountryViewModel: Decodable {
    //sys
    let country: String

}

struct TempViewModel: Decodable {
    //main
    let temp: Double
    let temp_min:Double //"temp_min"
    let temp_max:Double //"temp_max"
}

struct WeatherUICollectionCellViewModel{
    var weatherCellViewModel = [WeatherViewModel]()
    
}
