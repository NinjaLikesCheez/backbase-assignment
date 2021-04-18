//
//  backbase_assignmentTests.swift
//  backbase-assignmentTests
//
//  Created by ninja on 17/04/2021.
//

import XCTest
@testable import Backbase


class backbase_assignmentTests: XCTestCase {
    var locations: Locations!
    var tree: SearchTree!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        locations = LocationsManager().fetchLocations()
        tree = SearchTree()
        locations.forEach { tree.insert($0) }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        locations = nil
        try super.tearDownWithError()
    }

    func testSuccessfulSearches() throws {
        let searchTerms = [
            "London": 13,
            "Amsterdam": 4,
            "Hong Kong": 2,
            "‘": 21,
            "'": 2,
            "Rotterdam": 2,
            "Auckland": 4, // there certainly isn't really 3 Aucklands in NZ but sure
            "Cape Town": 1
        ]

        for (searchText, count) in searchTerms {
            let node = self.tree.search(searchText)
            let results = self.tree.getReachingLocationsFromNode(node).sorted()

            // Expected search counts align
            XCTAssert(results.count == count)

            for location in results {
                // Locations start with the prefix expected
                XCTAssert(location.getKey().normalizeForSearch().hasPrefix(searchText.normalizeForSearch()))
            }

            // Test against a known filtering method
            let filteredResults = self.locations.filter { $0.getKey().normalizeForSearch().hasPrefix(searchText.normalizeForSearch())
            }.sorted()

            XCTAssert(results == filteredResults)
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
            "WWQAD(WhatWouldQADo)"
        ]

        for searchText in searchTerms {
            let node = self.tree.search(searchText)
            let results = self.tree.getReachingLocationsFromNode(node).sorted()

            XCTAssert(results.isEmpty)

            // Test against known filtering method - we don't normalize the search text in this case
            let filteredResults = self.locations.filter {
                $0.getKey().normalizeForSearch().hasPrefix(searchText)
            }.sorted()

            XCTAssert(filteredResults.isEmpty)
        }
    }

    func testTreePerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let node = self.tree.search("Amsterdam")
            let _ = self.tree.getReachingLocationsFromNode(node).sorted()
        }
    }

    func testFilterPerformance() throws {
        self.measure {
            let _ = self.locations.filter { $0.getKey().normalizeForSearch().hasPrefix("Amsterdam".normalizeForSearch())
            }.sorted()
        }
    }
}
