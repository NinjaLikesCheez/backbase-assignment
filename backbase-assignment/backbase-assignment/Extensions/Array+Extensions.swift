//
//  Array+Extensions.swift
//  backbase-assignment
//
//  Created by ninja on 19/04/2021.
//

import Foundation

extension Array {
    /// Inserts into an array using the divide and conquer binary search method of finding an index
    mutating func insert(_ element: Element, withSort sort: (Element) -> Bool) {
        var begin = startIndex
        var end = endIndex

        while begin != end {
            // get the 'middle' of the slice we're inspecting
            let offset = distance(from: begin, to: end) / 2
            let middle = index(begin, offsetBy: offset)

            // if sort is true, shift the the slice 'up' the array
            if sort(self[middle]) {
                begin = index(after: middle)
            } else {
                // else, shift the end of the slice 'down' the array
                end = middle
            }
        }

        // begin is now our insertion index
        self.insert(element, at: begin)
    }
}
