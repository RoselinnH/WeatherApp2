//
//  DaysForcast.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-04-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation

struct TemperatureForDate {
    let date: Date
    let tempMin: String
    let tempMax: String
    let dailyIcon: String
}

struct MultiDayForcast {
    let city: String
    let weather: String
    let currentTemp: String
    let icon: String
    let temperatureForDates: [TemperatureForDate]
}
