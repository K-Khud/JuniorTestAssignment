//
//  JuniorDeveloperAssignmentTests.swift
//  JuniorDeveloperAssignmentTests
//
//  Created by Ekaterina Khudzhamkulova on 21.2.2021.
//

import XCTest
@testable import JuniorDeveloperAssignment

class JuniorDeveloperAssignmentTests: XCTestCase {
	var productsCache: ProductsCache!
	var glovesRepository: Repository!
	var glovesViewController: CategoryViewController!

    override func setUpWithError() throws {
		super.setUp()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
	func testTimestampValidation() throws {

	}

}
