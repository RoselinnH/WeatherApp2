//
//  WelcomePage.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-04-15.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class WelcomePageViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    @IBOutlet private var weatherApp: UILabel?
    
    override func viewDidLoad() {
        self.locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationManager.requestAlwaysAuthorization()
        if (status == .authorizedWhenInUse || status == .authorizedAlways){
            Thread.sleep(forTimeInterval: 0.5)
            let storyboard = UIStoryboard(name: "WeatherForcast", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else {return}
            self.navigationController?.show(viewController, sender: true)
            self.navigationItem.setHidesBackButton(true, animated:false)
        } else if (status == .denied) {
            guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
            UIApplication.shared.open(url)
        }
    }
}

extension WelcomePageViewController: CLLocationManagerDelegate {}
