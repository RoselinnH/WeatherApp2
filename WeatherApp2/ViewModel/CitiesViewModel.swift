//
//  CitiesViewModel.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-03-26.
//  Copyright © 2019 Rose H. All rights reserved.
//
import Foundation

class CitiesViewModel {
    private(set) var cities: [String] = []
    
    func search(text: String, then: () -> Void) -> Void {
        let webService = LocationService()
        webService.fetch(searchFieldText: text) { (cities) in
            var result = cities.map{"\($0.name), \($0.country)"}
            if !text.isEmpty {
                result = result.filter{ $0.localizedStandardContains(text) }
            }
            self.cities = result
            then()
        }
    }
}
