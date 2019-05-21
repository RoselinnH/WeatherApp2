//
//  CustomCell.swift
//  WeatherApp2
//
//  Created by Roselinn Hoareau on 2019-04-02.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    
    func setUp(with model: DayForcast) {
        dayLabel.text = model.day
        temperatureLabel.text = model.temperature
        loadImage(iconName: model.icon)
    }
    
    func loadImage(iconName: String) {
        DispatchQueue.global().async {
            if let url = URL(string: "http://openweathermap.org/img/w/\(iconName).png"),
                let data = try? Data(contentsOf: url){
                DispatchQueue.main.async { [weak self] in
                    self?.iconImageView.image = UIImage(data: data)
                }
            }
        }
    }
}
