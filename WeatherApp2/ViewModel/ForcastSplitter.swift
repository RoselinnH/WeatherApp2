//
//  SplittingForcast.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-03-27.
//  Copyright © 2019 Rose H. All rights reserved.
//
import Foundation

class ForcastSplitter {
    
    static func makeMultiDateForcast(weatherForcast: Forcast) -> MultiDayForcast? {
        guard let currentForcast = getCurrentForcast(for: weatherForcast) else {return nil}
        let city = weatherForcast.location.name
        let weather = currentForcast.weather[0].description
        let currentTemp = Int(currentForcast.temperature.temp)
        let icon = currentForcast.weather[0].icon
        
        var temperatureForDates = [TemperatureForDate]()
        let forcastSplitByDay = splitByDay(weatherForcast: weatherForcast)
        forcastSplitByDay.forEach { (key: Date, value: [TimedForcast]) in
            if let x = temperatureForDateConverter(date: key, timedForcasts: value) {
                temperatureForDates.append(x)
            }
        }
        temperatureForDates.sort { $0.date < $1.date }
        guard temperatureForDates.count >= 5 else {return nil}
        let multiDayForcast = MultiDayForcast(city: city, weather: weather, currentTemp: String(currentTemp), icon: icon, temperatureForDates: temperatureForDates)
        return multiDayForcast
    }
    
    static func getCurrentForcast(for forcast: Forcast) -> TimedForcast? {
        let sortedForcast = forcast.timedForcast.sorted { $0.dateTime < $1.dateTime }
        return sortedForcast.first
    }
    
    static func splitByDay(weatherForcast: Forcast) -> [Date: [TimedForcast]] {
        var forcastsByDay = [Date: [TimedForcast]]()
        
        for timedForcast in weatherForcast.timedForcast {
            let day = Calendar.current.startOfDay(for: timedForcast.dateTime)
            if var mutableValue = forcastsByDay[day] {
                mutableValue.append(timedForcast)
                forcastsByDay[day] = mutableValue
            } else {
                forcastsByDay[day] = [timedForcast]
            }
        }
        return forcastsByDay
    }
    
    static func temperatureForDateConverter (date: Date, timedForcasts: [TimedForcast]) -> TemperatureForDate? {
        var tempMins = [Int]()
        var tempMaxs = [Int]()
        timedForcasts.forEach { timedForcast in
            tempMins.append(Int(timedForcast.temperature.tempMin))
            tempMaxs.append(Int(timedForcast.temperature.tempMax))
        }
        
        guard let tempMin = tempMins.min(), let tempMax = tempMaxs.max() else {return nil}
        let sortedTimedForcasts = timedForcasts.sorted {$0.dateTime < $1.dateTime}
        let icon = sortedTimedForcasts[0].weather[0].icon
        let temperatureForDay = TemperatureForDate(date: date, tempMin: String(tempMin), tempMax: String(tempMax), dailyIcon: icon)
        return temperatureForDay
    }
}
