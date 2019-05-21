//
//  WeatherForecastViewModel.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-09.
//  Copyright © 2019 Rose H. All rights reserved.
//
import Foundation

struct DateFormatError: Error {}

struct Forcast : Decodable {
    let timedForcast : [TimedForcast]
    let location : Location
    
    enum CodingKeys: String, CodingKey {
        case timedForcast = "list"
        case location = "city"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        timedForcast = try values.decode([TimedForcast].self, forKey: .timedForcast)
        location = try values.decode(Location.self, forKey: .location)
    }
    
    init(timedForcast: [TimedForcast], location: Location) {
        self.timedForcast = timedForcast
        self.location = location
    }
}
struct TimedForcast : Decodable {
    let temperature : TempList
    let weather : [Weather]
    let dateTime : Date
    
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather = "weather"
        case dateTime = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try values.decode(TempList.self, forKey: .temperature)
        weather = try values.decode([Weather].self, forKey: .weather)
        let dateTimeString = try values.decode(String.self, forKey: .dateTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let convertToDateTime = dateFormatter.date(from: dateTimeString) else {throw DateFormatError()}
        dateTime = convertToDateTime
    }
    
    init(temperature: TempList, weather: [Weather], date: Date)  {
        self.temperature = temperature
        self.weather = weather
        self.dateTime = date
    }
}

struct TempList : Decodable {
    let temp : Double
    let tempMin : Double
    let tempMax : Double
    let humidity : Int
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity = "humidity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decode(Double.self, forKey: .temp)
        tempMin = try values.decode(Double.self, forKey: .tempMin)
        tempMax = try values.decode(Double.self, forKey: .tempMax)
        humidity = try values.decode(Int.self, forKey: .humidity)
    }
    
    init(temp: Double, tempMin: Double, tempMax: Double, humidity: Int ) {
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.humidity = humidity
    }
}

struct Weather : Decodable {
    let description : String
    let icon : String
}

struct Location : Decodable {
    let name : String
    let country : String
}
