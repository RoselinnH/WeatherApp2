//
//  WeatherForecastViewModel.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-09.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation



struct WeatherViewModel: Decodable {
    //it is being returned meaning no key
    let name: String //city

    //main
    let main: TempViewModel
    let weather: IconViewModel
    let sys: CountryViewModel
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case main = "main"
        case weather = "weather"
        case sys = "sys"
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
