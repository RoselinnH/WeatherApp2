//
//  AddCityForcastViewController.swift
//  WeatherApp2
//
//  Created by Rose H on 2019-01-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit

protocol CitySelectionDelegate: class {
    func selectedCity(selectedCity: String)
}

class SelectCityController: UITableViewController {
    
    @IBOutlet private var searchTextField: UISearchBar!
    private let citiesViewModel = CitiesViewModel()
    weak var citySelectedDelegate: CitySelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.citiesViewModel.search(text: "") { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.citiesViewModel.cities.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = self.citiesViewModel.cities[indexPath.row]
        self.citySelectedDelegate?.selectedCity(selectedCity: selectedCity)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellID")
        cell?.textLabel?.text = self.citiesViewModel.cities[indexPath.row]
        return cell!
    }
}

extension SelectCityController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.citiesViewModel.search(text: searchText) {
            self.tableView.reloadData()
        }
    }
}
