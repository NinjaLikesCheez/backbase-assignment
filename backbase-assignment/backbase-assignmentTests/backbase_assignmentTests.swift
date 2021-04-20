//
//  backbase_assignmentTests.swift
//  backbase-assignmentTests
//
//  Created by ninja on 17/04/2021.
//

import XCTest
@testable import Backbase


class backbase_assignmentTests: XCTestCase {
    let manager = LocationsManager.instance
    var locations: Locations!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        let locationExpectation = expectation(description: "\(#function)\(#line)")

        manager.getLocations {
            self.locations = $0
            locationExpectation.fulfill()
        }

        waitForExpectations(timeout: 25)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        locations = nil
        try super.tearDownWithError()
    }

    func getFilteredResults(_ locations: Locations, searchTerm: String) -> Locations {
        return manager.locations
            .filter { $0.displayName.lowercased().hasPrefix(searchTerm.lowercased()) }
            .sorted()
    }

    /// This tests an edge case where .filter().sort() gets the order of a case wrong but the radix tree gets it right
    func testFilterBehavior() throws {
        let searchTerms = ["‘Alī": 2]

        for (searchText, count) in searchTerms {
            let results = manager.search(searchText)

            XCTAssertTrue(results.count == count)

            let filteredResults = getFilteredResults(manager.locations, searchTerm: searchText)

            XCTAssertTrue(filteredResults.count == count)

            // This is expected to return false, for some reason filter().sort() orders 'm' before 'a' in these cases
            XCTAssertFalse(results == filteredResults)
        }
    }

    func testSuccessfulSearches() throws {
        let searchTerms = [
            "London": 13,
            "Amsterdam": 4,
            "Hong Kong": 2,
            "'": 2,
            "Rotterdam": 2,
            "Auckland": 4, // there certainly isn't really 3 Aucklands in NZ but sure
            "Cape Town": 1,
            "Amsterdam, NL": 1 // Test a previous issue where termination nodes weren't added when the key matched exactly
        ]

        for (searchText, count) in searchTerms {
            let results = manager.search(searchText)

            // Expected search counts align
            XCTAssert(results.count == count, "Results do not contain the expected count: \(results.count) vs \(count)")

            let searchTermLowercased = searchText.lowercased()

            for location in results {
                // Locations start with the prefix expected
                let displayNameLowercased = location.displayName.lowercased()

                XCTAssertTrue(displayNameLowercased.hasPrefix(searchTermLowercased))
            }

            // Test against a known filtering method
            let filteredResults = getFilteredResults(manager.locations, searchTerm: searchTermLowercased)

            XCTAssertEqual(results.count, filteredResults.count)

            for i in 0...(results.count - 1) {
                let resultsIndex = results.index(results.startIndex, offsetBy: i)
                let filteredIndex = filteredResults.index(filteredResults.startIndex, offsetBy: i)

                let resultsDisplayName = results[resultsIndex].displayName
                let filteredDisplayName = filteredResults[filteredIndex].displayName

                XCTAssertEqual(resultsDisplayName, filteredDisplayName)
            }
        }
    }

    func testUnsuccessfulSearches() throws {
        let searchTerms = [
            "Londonnnnnnnnn",
            "amstee",
            "ajsdha",
            "''",
            "          ",
            "-*()",
            "thisIsABadSearch",
            "WWQAD(WhatWouldQADo)",
            "L o n d o n"
        ]

        for searchText in searchTerms {
            let results = manager.search(searchText)

            XCTAssert(results.isEmpty)

            // Test against known filtering method
            let filteredResults = getFilteredResults(manager.locations, searchTerm: searchText)

            XCTAssert(filteredResults.isEmpty)
        }
    }

    func testTreeInsertion() throws {
        let tree = RadixTree()
        let locationOne = Location(
            name: "London", country: "GB", id: 12345, coordinates: Location.Coordinates(longitude: 1234, latitude: 1234)
        )

        let locationTwo = Location(
            name: "Londonderry", country: "GB", id: 12345, coordinates: Location.Coordinates(longitude: 1234, latitude: 1234)
        )

        tree.insert(locationOne)

        XCTAssertEqual(tree.root.children.count, 1)
        XCTAssertEqual(tree.root.children[0].value, "london, gb") // values are lowercased
        XCTAssertEqual(tree.root.children[0].locations![0], locationOne)

        tree.insert(locationTwo)

        XCTAssertEqual(tree.root.children.count, 1) // One node is expected, any more and we've not split the prefix correctly
        XCTAssertEqual(tree.root.children[0].value, "london") // test prefix splitting and insertion works
        XCTAssertEqual(tree.root.children[0].children[0].locations![0], locationOne)
        XCTAssertEqual(tree.root.children[0].children[1].locations![0], locationOne)
    }

    func testTreePerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = manager.search("Amsterdam")

        }
    }

    func testFilterPerformance() throws {
        self.measure {
            let _ = manager.locations.filter { $0.displayName.lowercased().hasPrefix("Amsterdam".lowercased())}.sorted()
        }
    }
}
