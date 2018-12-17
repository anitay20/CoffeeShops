//
//  ViewControllerTests.swift
//  CoffeeShopsTests
//
//  Created by anita on 12/15/18.
//  Copyright © 2018 anita. All rights reserved.
//

import XCTest

@testable import CoffeeShops

class ViewControllerTests: XCTestCase {

    var viewController: ViewController!
    var tableView: UITableView!
    var dataSource: UITableViewDataSource!
    var delegate: UITableViewDelegate!
    
    override func setUp() {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self)).instantiateInitialViewController() as? ViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        viewController = vc
        viewController.loadViewIfNeeded()
        
        tableView = viewController.venuesTableView
        
        guard let ds = tableView.dataSource else {
            return XCTFail("View Controller's venuesTableView should have a data source.")
        }
        dataSource = ds
        delegate = tableView.delegate
    }
    
    func testControllerHasTableView() {
        XCTAssertNotNil(viewController.venuesTableView, "Controller should have venuesTableView")
    }

    func testTableViewHasDataSource() {
        XCTAssertTrue(viewController.venuesTableView.dataSource is ViewController, "venuesTableView data source should be self (ViewController).")
    }
    
    func testTableViewHasCells() {
        let cell = viewController.venuesTableView.dequeueReusableCell(withIdentifier: "VenueCell")
        XCTAssertNotNil(cell, "venuesTableView should be able to dequeue cell with identifier: VenueCell")
    }
    
    
}
