//
//  TestWebServices.swift
//  WeatherApp2Tests
//
//  Created by Roselinn Hoareau on 2019-04-30.
//  Copyright © 2019 Rose H. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import WeatherApp2

class WebServicesJsonTest: XCTestCase {
    
    struct ServerError: Error {}
    
    func test_downloadWeather_ValideJsonData_ReturnsForcast() {
        self.stubWebCallSuccess()
        let sut = Webservices()
        var result: (forcast: Forcast?, error: Error?)?
        let expectation = self.expectation(description: "result returned")
        
        sut.downloadWeather(city: "Toronto", countryCode: "CA") { (forcast, error) in
            result = (forcast, error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(result?.error == nil)
        XCTAssert(result?.forcast != nil)
    }
    
    func test_downloadWeather_InvalideJsonData_ReturnsError() {
        self.stubWebCallIncorrectJson()
        let sut = Webservices()
        var result: (forcast: Forcast?, error: Error?)?
        let expectation = self.expectation(description: "result returned")
        
        sut.downloadWeather(city: "Toronto", countryCode: "CA") { (forcast, error) in
            result = (forcast, error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(result?.error != nil)
        XCTAssert(result?.forcast == nil)
    }
    
    func test_downloadWeather_ServerError_ReturnsError() {
        self.stubWebServiceStatusCode_FailureCode500()
        let sut = Webservices()
        var result: (forcast: Forcast?, error: Error?)?
        let expectation = self.expectation(description: "result returned")
        
        sut.downloadWeather(city: "Toronto", countryCode: "CA") { (forcast, error) in
            result = (forcast, error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(result?.error != nil)
        XCTAssert(result?.forcast == nil)
    }
    
    // MARK: - Helpers
        
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    private func stubWebCallSuccess() {
        stub(condition: isHost("api.openweathermap.org") , response: { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("JsonData.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        })
    }
    
    private func stubWebCallIncorrectJson() {
        stub(condition: isHost("api.openweathermap.org") , response: { _ in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("IncorrectJsonData.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type":"application/json"]
            )
        })
    }
    
    private func stubWebServiceStatusCode_FailureCode500() {
        stub(condition: isHost("api.openweathermap.org") , response: { _ in
            return OHHTTPStubsResponse(error: ServerError() )
        })
    }
}
