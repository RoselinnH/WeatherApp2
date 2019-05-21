//
//  ToBeNamed.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-03-08.
//  Copyright © 2019 Rose H. All rights reserved.
//
import Foundation

struct DayForcast {
    let day: String
    let icon: String
    let temperature: String
}

class CityForcastViewModel {
    private let webService = Webservices()
    private var fiveDayForcast = [Dictionary<String, String>]()
    private(set) var multiDayForcast: MultiDayForcast?
    private(set) var dayForcasts = [DayForcast]()
    
    func getCityForcast(city: String, countryCode: String, then: @escaping () -> Void) {
        self.webService.downloadWeather(city: city, countryCode: countryCode){ [weak self] (content, error) in
            guard let self = self else {return}
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let contentData = content else { return }
            self.multiDayForcast = ForcastSplitter.makeMultiDateForcast(weatherForcast: contentData)
            guard let multiDayForcast = self.multiDayForcast else {return}
            self.dayForcasts = self.makeDayForcast(multiDayForcast: multiDayForcast)
            then()
        }
    }
    
    func makeDayForcast(multiDayForcast: MultiDayForcast) -> [DayForcast] {
        let dayForcasts = multiDayForcast.temperatureForDates.map { (forcast) -> DayForcast in
            let day = self.getDate(date: forcast.date)
            let icon = forcast.dailyIcon
            let temp = forcast.tempMax + "   " + forcast.tempMin
            return DayForcast(day: day, icon: icon, temperature: temp)
        }
        return dayForcasts
    }
    
    func getDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_CA")
        let day = dateFormatter.string(from: date)
        return day
    }
}
