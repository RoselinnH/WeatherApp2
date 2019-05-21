//
//  TestSelectCityViewController.swift
//  WeatherApp2Tests
//
//  Created by Roselinn Hoareau on 2019-05-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import  XCTest
import OHHTTPStubs
@testable import WeatherApp2
import UIKit
class TestSelectCityViewController: XCTestCase {
    var selectCity: SelectCityController!
    var tableViewController = UITableViewController()
    let location = LocationService()
    var searchTextField = UISearchBar()
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "SelectCity", bundle: nil)
        self.selectCity = storyboard.instantiateInitialViewController() as? SelectCityController
        self.selectCity.loadView()
        self.selectCity.viewDidLoad()
    }
    
    func test_hasATableView() {
        XCTAssertNotNil(self.selectCity.tableView)
    }
    
    func test_tableView_hasDelegate() {
        XCTAssertNotNil(self.selectCity.tableView.delegate)
    }
    
    func test_tableView_hasDataSource() {
        XCTAssertNotNil(self.selectCity.tableView.dataSource)
    }
    
    func test_tableView_confromsToTableViewDelegateProtocol() {
        XCTAssertTrue(self.selectCity.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(self.selectCity.responds(to: #selector(self.selectCity.tableView(_:didSelectRowAt:))))
    }
    
    func test_HasSearchBar() {
        XCTAssertNotNil(self.selectCity.searchBar)
    }
    
    func test_tableView_ConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(self.selectCity.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(self.selectCity.responds(to: #selector(self.selectCity.tableView(_:didSelectRowAt:))))
    }
    
    func test_tableView_conformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(self.selectCity.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(self.selectCity.responds(to: #selector(self.selectCity.numberOfSections(in:))))
        XCTAssertTrue(self.selectCity.responds(to: #selector(self.selectCity.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(self.selectCity.responds(to: #selector(self.selectCity.tableView(_:cellForRowAt:))))
    }
    
    func test_tableCell_HasCorrectNumberOfCells() {
        XCTAssertEqual(self.selectCity.tableView.numberOfRows(inSection: 0), location.result.count)
    }
    
    func test_tableCell_HasCorrectLabelText() {
        let locationArray = location.result
        let firstCell = self.selectCity.tableView(self.selectCity.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(firstCell.textLabel!.text, "\(locationArray[0].name), \(locationArray[0].country)")
        
        let secondCell = self.selectCity.tableView(self.selectCity.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        XCTAssertEqual(secondCell.textLabel!.text, "\(locationArray[1].name), \(locationArray[1].country)")
        
        let thirdCell = self.selectCity.tableView(self.selectCity.tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        XCTAssertEqual(thirdCell.textLabel!.text, "\(locationArray[2].name), \(locationArray[2].country)")
    }
    
    func test_searchBar_textDidChangeCallsReloadData_valueOfExistingLocation_newCell_ContainsCoeerectData() {
        self.selectCity.searchBar(searchTextField, textDidChange: "P")
        let firstNewCell = self.selectCity.tableView(self.selectCity.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let secondNewCell = self.selectCity.tableView(self.selectCity.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(firstNewCell.textLabel?.text, "Paris, FR")
        XCTAssertEqual(secondNewCell.textLabel?.text, "Phoenix, US")
    }
    
    func test_searchBar_textDidChangeCallsReloadData_valueOfNoneExistingLocation_NoCells(){
        var correctData = false
        self.selectCity.searchBar(searchTextField, textDidChange: "k")
        
        if self.selectCity.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) == nil {
            correctData = true
        }
        
        XCTAssertTrue(correctData)
    }
}
