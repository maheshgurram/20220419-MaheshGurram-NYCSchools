//
//  SchoolDetailTest.swift
//  20220419-MaheshGurram-NYCSchoolsTests
//
//  Created by Mahesh on 4/19/22.
//

import XCTest
@testable import _0220419_MaheshGurram_NYCSchools

class SchoolDetailTest: XCTestCase {

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
    
    func testRequirement()  {
        let school = School(dbn: "1", school_name: "Clinton School Writers & Artists, M.S. 260", requirement1_1: "Must have English >85", requirement2_1: "Standardized Test Scores: English Language Arts (2.8-4.5), Math (2.8-4.5)", requirement3_1: "Attendance and Punctuality")
        
        let reqs = OverviewCell().prepareRequirement(school: school)
        
        assert(reqs == "- Must have English >85 \n- Standardized Test Scores: English Language Arts (2.8-4.5), Math (2.8-4.5) \n- Attendance and Punctuality \n", "Requirement preparation failed")
        
    }
    
    func testNoRequirementData() {
        let school = School(dbn: "1", school_name: "Clinton School Writers & Artists, M.S. 260")
        
        let reqs = OverviewCell().prepareRequirement(school: school)
        
        assert(reqs == "", "Requirement preparation failed")
    }
    
    func testAddressData() {
        let school = School(dbn: "1", school_name: "Clinton School Writers & Artists, M.S. 260", primary_address_line_1: "10 East 15th Street", city: "Manhattan", state_code: "NY", zip: "10003")
        
        let address = AddressCell().prepareAddress(school: school)
        
        assert(address == "10 East 15th Street \nManhattan \nNY, 10003 \n", "Address preparation failed")
    }
    
    func testNoAddressData() {
        let school = School(dbn: "1", school_name: "Clinton School Writers & Artists, M.S. 260")
        
        let address = AddressCell().prepareAddress(school: school)
        
        assert(address == "", "Address preparation failed")
    }

}
