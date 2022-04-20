//
//  NetworkManagerTest.swift
//  20220419-MaheshGurram-NYCSchoolsTests
//
//  Created by Mahesh on 4/19/22.
//

import XCTest
@testable import _0220419_MaheshGurram_NYCSchools

class NetworkManagerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetScore() {
        let schoolId = "25Q285"
        let url = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?dbn=\(schoolId)"
        let network = NetworkManager()
        let expectation = expectation(description: "wait for URL to load")
        var schools: [School]?
        
        
        network.getData(url: url, type: [School].self, completion: { data, error in
            if let err = error {
                print("Error occured while making api call\(err)")
                XCTFail("API call failed")
            } else {
                if let data = data {
                    schools = data
                }
                expectation.fulfill()
            }
        })
        
        waitForExpectations(timeout: 5)
        XCTAssertGreaterThan((schools?.count)!, 0)
        
        
    }

}
