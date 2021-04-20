//
//  RadixNode.swift
//  backbase-assignment
//
//  Created by ninja on 19/04/2021.
//

import Foundation

/// Represents a radix node in a tree
class RadixNode {
    /// The parent of this node
    weak var parent: RadixNode?
    /// A list of children nodes
    var children: [RadixNode]
    /// The prefix value this node represents
    var value: String
    /// The locations this node represents
    /// - Note: This will only be attached to nodes that terminate the branch of the tree
    var locations: Locations?

    init(_ value: String, children: [RadixNode] = [], parent: RadixNode? = nil) {
        self.children = children
        self.parent = parent
        self.value = value

        for child in children {
            child.parent = self
        }
    }

    /// Inserts a child into this node
    /// - Note: this places the child in alphabetical order based on the prefix value it represents
    public func insertChild(_ child: RadixNode) {
        children.insert(child, withSort: { $0.value < child.value })
    }

    /// Inserts a location into this node
    /// - Note: If there are other locations, this will insert in an sorted fashion
    public func insertLocation(_ location: Location) {
        locations == nil ? locations = [location] : locations?.insert(location, withSort: { $0.name < location.name })
    }

    /// Inserts a list of locations into this node
    /// - Note: This will insert in an sorted fashion
    public func insertLocations(_ locations: Locations?) {
        guard let locationsToInsert = locations else { return }
        if self.locations == nil {
            self.locations = locationsToInsert.sorted()
            return
        }

        for location in locationsToInsert {
            self.locations?.insert(location, withSort: { $0.name < location.name })
        }
    }
}
