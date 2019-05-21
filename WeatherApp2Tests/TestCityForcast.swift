//
//  TestCityForcast.swift
//  WeatherApp2Tests
//
//  Created by Roselinn Hoareau on 2019-05-02.
//  Copyright © 2019 Rose H. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import WeatherApp2

class TestCityForcast: XCTestCase {
    let cityForcastViewModel = CityForcastViewModel()
    let webService = Webservices()
    
    func test_getCityForecast_callsThenClosure() {
        stubWebCallSuccess()
        var thenClosureCalled = false
        let expectation = self.expectation(description: "result returned")
        
        cityForcastViewModel.getCityForcast(city: "Montreal", countryCode: "CA") {
            thenClosureCalled = true
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssert(thenClosureCalled == true)
    }
    
    func test_getCityForcast_wehnContentIsNil_thenNotCalled()  {
        var result: (forcast: Forcast?, error: Error?)
        let incorrectCountryCode = "LA"
        let expectation = self.expectation(description: "result returned")
        self.cityForcastViewModel.getCityForcast(city: "Montreal", countryCode: "CA") { [weak self] in
            self?.webService.downloadWeather(city: "Montreal", countryCode: incorrectCountryCode, then: { (forcast, error) in
                result = (forcast, error)
            })
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
        XCTAssert(result.forcast == nil)
    }
    
    func test_makeDayForcast_withMultidayForcast_returnsDayForcast() {
        var count = 0
        var timeInterval: Double
        var temperatureForDateArray: [TemperatureForDate] = []
        
        while (count != 6) {
            timeInterval = Double(24 * count)
            let temperatureForDate = [TemperatureForDate(date: Date().addingTimeInterval(timeInterval * 3600.0), tempMin: "23.5", tempMax: "24.2", dailyIcon: "01n")]
            temperatureForDateArray.append(contentsOf: temperatureForDate)
            count += 1
        }
        let multiDayForcast = MultiDayForcast(city: "Sydney", weather: "Australia", currentTemp: "23.8", icon: "25.6", temperatureForDates: temperatureForDateArray )
        let dayForcastArray = cityForcastViewModel.makeDayForcast(multiDayForcast: multiDayForcast)
        
        XCTAssert(dayForcastArray.isEmpty == false)
    }
    
    func test_GetDate_returnsWeekDay() {
        let result = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "2019/05/18 20:31")
        let sut = cityForcastViewModel.getDate(date: someDateTime!)
        
        XCTAssert(result.contains(sut))
    }
    
    func test_getCityForcast_whenContentIsNil_thenCloserIsNotCalled() {
        stubWebCallFailure_withError()
        let expectation = self.expectation(description: "result returned")
        expectation.isInverted = true
        cityForcastViewModel.getCityForcast(city: "", countryCode: "", then: {
            expectation.fulfill()
        })
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func test_getCityForcast_multiDayFocast_isNotSet_thenCloserIsNotCalled() {
        stubWebCallSuccess_withShortenedJsonData()
        let expectation = self.expectation(description: "result returned")
        expectation.isInverted = true
        self.cityForcastViewModel.getCityForcast(city: "Montreal", countryCode: "CA", then: {
            expectation.fulfill()
        })
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    // Mark : - Helper
    func stubWebCallSuccess() {
        stub(condition: isHost("api.openweathermap.org") , response: { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("JsonData.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        })
    }
    
    func stubWebCallFailure() {
        stub(condition: isHost("api.openweathermap.com") , response: { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("JsonData.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        })
    }
    
    func stubWebCallFailure_withError() {
        stub(condition: isHost("api.openweathermap.com") , response: { _ in
            return OHHTTPStubsResponse(error: AnyError())
        })
    }
    
    func stubWebCallSuccess_withShortenedJsonData() {
        stub(condition: isHost("api.openweathermap.org") , response: { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("ShortenedJsonData.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        })
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    struct AnyError: Error { }
}
