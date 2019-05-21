//
//  LocationService.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-03-27.
//  Copyright © 2019 Rose H. All rights reserved.
//
import CoreLocation

class LocationService {
    
    let result = [City(name: "Montreal", country: "CA"),
                  City(name: "Calgary", country: "CA"),
                  City(name: "Edmonton", country: "CA"),
                  City(name: "Leduc", country: "CA"),
                  City(name: "Vancouver", country: "CA"),
                  City(name: "Ottawa", country: "CA"),
                  City(name: "Saguenay", country: "CA"),
                  City(name: "Paris", country: "FR"),
                  City(name: "Marseille", country: "FR"),
                  City(name: "Lyon", country: "FR"),
                  City(name: "Toulouse", country: "FR"),
                  City(name: "Nice", country: "FR"),
                  City(name: "Victoria", country: "SC"),
                  City(name: "Anse Boileau", country: "SC"),
                  City(name: "Phoenix", country: "US"),
                  City(name: "Tuscaloosa", country: "US")
    ]
    
    func fetch(searchFieldText: String, then: ([City]) -> Void) -> Void {
        then(self.result)
    }
}
