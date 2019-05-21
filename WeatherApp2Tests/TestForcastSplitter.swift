//
//  TestForcastSplitter.swift
//  WeatherApp2Tests
//
//  Created by Roselinn Hoareau on 2019-05-01.
//  Copyright © 2019 Rose H. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import WeatherApp2

class TestForcastSplitter: XCTestCase {
    
    func test_getCurrentForecast_withForecast_returnsTemperatureForDate() {
        let forcast = self.createForcastUsingJsonData()
        let sut = ForcastSplitter.getCurrentForcast(for: forcast)
        
        XCTAssert(sut?.dateTime == forcast.timedForcast.first?.dateTime )
        XCTAssert(sut?.temperature.tempMin == forcast.timedForcast.first?.temperature.tempMin)
        XCTAssert(sut?.temperature.tempMax == forcast.timedForcast.first?.temperature.tempMax)
        XCTAssert(sut?.temperature.temp == forcast.timedForcast.first?.temperature.tempMin)
        XCTAssert(sut?.temperature.humidity == forcast.timedForcast.first?.temperature.humidity)
        XCTAssert(sut?.weather[0].icon == forcast.timedForcast.first?.weather[0].icon)
        XCTAssert(sut?.weather[0].description == forcast.timedForcast.first?.weather[0].description)
    }
    
    func test_getCurrentForecast_withEmptyForecast_returnsNil() {
        let location = Location(name: "Montreal", country: "CA")
        let forecast = Forcast(timedForcast: [], location: location)
        let sut = ForcastSplitter.getCurrentForcast(for: forecast)
        
        XCTAssert(sut == nil)
    }
    
    func test_splitByDay_withFiveForcast_returnsFiveTimeForcastForcastByDay() {
        let forecast = createForcastUsingJsonData()
        let sut = ForcastSplitter.splitByDay(weatherForcast: forecast)
        
        print(sut.count)
        XCTAssert(sut.count == 5 )
    }
    
    func test_splitByDay_withZeroForcast_returnsEmptyFocastByDay() {
        let forecast = getForcastWithEmptyTimedForcastArray()
        let sut = ForcastSplitter.splitByDay(weatherForcast: forecast)
        
        print(sut.count)
        XCTAssert(sut.count == 0)
    }
    
    func test_makeMultiDateForecast_whenTemperatureForDatesIsEmpty_returnsNil() {
        let forecast = getForcastWithEmptyTimedForcastArray()
        let sut = ForcastSplitter.makeMultiDateForcast(weatherForcast: forecast)
        
        XCTAssert(sut == nil)
    }
    
    func test_makeMultiDateForecast_whenTemperatureForDatesIsOne_returnsNil() {
        let forecast = getForcastWithXNumberOfTimedForcast(numberOfDays: 1)
        
        let sut = ForcastSplitter.makeMultiDateForcast(weatherForcast: forecast)
        XCTAssert(sut?.temperatureForDates == nil)
    }
    
    func test_makeMultiDateForecast_whenTemperatureForDatesIsFour_returnsNil() {
        let forecast = getForcastWithXNumberOfTimedForcast(numberOfDays: 4)
        let sut = ForcastSplitter.makeMultiDateForcast(weatherForcast: forecast)
        
        XCTAssert(sut?.temperatureForDates == nil)
    }
    
    func test_makeMultiDateForecast_whenTemperatureForDatesIsFive_returnsNil() {
        let forecast = getForcastWithXNumberOfTimedForcast(numberOfDays: 5)
        let sut = ForcastSplitter.makeMultiDateForcast(weatherForcast: forecast)
        
        XCTAssert(sut?.temperatureForDates != nil)
    }
    
    func test_makeMultiDateForecast_whenTemperatureForDatesIsSeven_returnsNil() {
        let forecast = getForcastWithXNumberOfTimedForcast(numberOfDays: 7)
        let sut = ForcastSplitter.makeMultiDateForcast(weatherForcast: forecast)
        
        XCTAssert(sut?.temperatureForDates != nil)
    }
    
    func test_temperatureForDate_withTimedForcast_returnsAValue() {
        let timedForcast = getTimedForcast()
        let temperatureForDate = ForcastSplitter.temperatureForDateConverter(date: Date(), timedForcasts: timedForcast)
        
        XCTAssert(temperatureForDate != nil)
    }
    
    func test_temperatureForDate_withTimedForcast_whenMaxIsHigherThanMin_returnsTemperatureForDate() {
        let timedForcast = getTimedForcast()
        let temperatureForDate = ForcastSplitter.temperatureForDateConverter(date: Date(), timedForcasts: timedForcast)
        guard let tempMax = temperatureForDate?.tempMax,
            let tempMin = temperatureForDate?.tempMin
            else {return}
        
        let tempMaxIsHigherThanTempMin = (tempMax as NSString).doubleValue > (tempMin as NSString).doubleValue
        
        XCTAssert(tempMaxIsHigherThanTempMin == true)
    }
    
    func test_temperatureForDate_withTimedForcast_returnsTemperatureForDateWithCorrectTempMinAndMax() {
        let timedForcast = self.getTimedForcast()
        var correctData = false
        var tempMinArray = [Double]()
        var tempMaxArray = [Double]()
        let temperatureForDate = ForcastSplitter.temperatureForDateConverter(date: Date(), timedForcasts: timedForcast)
        guard let tempMax = temperatureForDate?.tempMax,
            let tempMin = temperatureForDate?.tempMin
            else {return}
        
        timedForcast.forEach { (timedForcast) in
            tempMinArray.append(Double(timedForcast.temperature.tempMin))
            tempMaxArray.append(Double(timedForcast.temperature.tempMax))
        }
        
        correctData = Double(tempMin) == tempMinArray.sorted().first && Double(tempMax) == tempMaxArray.sorted().last ? true : false
        
        XCTAssert(correctData)
    }
    
    func test_temperatureForDateConverter_withEmptyTimedForcast_returnsNil() {
        let temperatureForDay = ForcastSplitter.temperatureForDateConverter(date: Date(), timedForcasts: [])
        
        XCTAssert(temperatureForDay == nil)
    }
    
    // MARK: - Helper
    func createForcastUsingJsonData() -> Forcast {
        let decoder = JSONDecoder()
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "JsonData", withExtension: "json")!
        let data = try! Data(contentsOf: url, options: [])
        let forcast = try! decoder.decode(Forcast.self, from: data)
        return forcast
    }
    
    
    func getForcastWithEmptyTimedForcastArray() -> Forcast {
        let location = Location(name: "Montreal", country: "CA")
        return Forcast(timedForcast: [], location: location)
    }
    
    func getForcastWithXNumberOfTimedForcast(numberOfDays: Int) -> Forcast {
        var count = 0
        var timedForcast: [TimedForcast] = []
        let location = Location(name: "Montreal", country: "CA")
        let tempList = TempList(temp: 25, tempMin: 20, tempMax: 26.5, humidity: 10)
        let weather = [Weather(description: "sunny sky", icon: "01n")]
        var timeInterval: Double
        
        while (count != numberOfDays) {
            timeInterval = Double(24 * count)
            let aTimedForcast = [TimedForcast(temperature: tempList , weather: weather, date: Date().addingTimeInterval(timeInterval * 3600.0))]
            timedForcast.append(contentsOf: aTimedForcast)
            count += 1
        }
        let forecast = Forcast(timedForcast: timedForcast, location: location)
        return forecast
    }
    
    func getTimedForcast() -> [TimedForcast] {
        var timedForcast : [TimedForcast] = []
        var count = 0
        var min = 1.0
        var max = 2.0
        var timeInterval: Double
        var tempList: TempList
        var weather: [Weather]
        
        repeat {
            timeInterval = Double(24 * count)
            tempList = TempList(temp: 29.5, tempMin: min, tempMax: max, humidity: 9)
            weather = [Weather(description: "blue skies", icon: "01n")]
            let aTimedforcast = TimedForcast(temperature: tempList, weather: weather, date: Date().addingTimeInterval(timeInterval * 3600.0))
            timedForcast.append(aTimedforcast)
            min += 5
            max += 5
            count += 1
        } while (count != 5)
        return timedForcast
    }
}
