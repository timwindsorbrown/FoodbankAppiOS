//
//  FoodbankAppTests.swift
//  FoodbankAppTests
//
//  Created by Tim Windsor Brown on 01/05/2017.
//  Copyright © 2017 Tim Windsor Brown. All rights reserved.
//

import XCTest
@testable import FoodbankApp

class FoodbankAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadData() {
        
        let expectation = self.expectation(description: "Has loaded + parsed foodbank data")
        APIManager.loadAllDataForFoodbank(foodbankID: 50) { (items:[FoodItem]?, error:APIManager.ErrorType?) in
            
            if let items = items {
                items.forEach({ print($0) })
            }
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
        
    }
    
}
