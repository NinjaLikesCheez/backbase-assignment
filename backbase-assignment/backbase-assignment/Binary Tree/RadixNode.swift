//
//  RadixNode.swift
//  backbase-assignment
//
//  Created by ninja on 19/04/2021.
//

import Foundation

class RadixNode {
    weak var parent: RadixNode?
    var children: [RadixNode]
    var value: String
    var locations: Locations?

    convenience init(value: String, child: RadixNode, parent: RadixNode? = nil) {
        self.init(value, children: [child], parent: parent)
    }

    init(_ value: String, children: [RadixNode] = [], parent: RadixNode? = nil) {
        self.children = children
        self.parent = parent
        self.value = value

        for child in children {
            child.parent = self
        }
    }

    public func insertChild(_ child: RadixNode) {
        children.insert(child, withSort: { $0.value < child.value })
    }

    public func insertLocation(_ location: Location) {
        locations == nil ? locations = [location] : locations?.insert(location, withSort: { $0.name < location.name })
    }

    public func insertLocations(_ locations: Locations?) {
        guard let locationsToInsert = locations else { return }
        if self.locations == nil {
            self.locations = locationsToInsert
            return
        }

        for location in locationsToInsert {
            self.locations?.insert(location, withSort: { $0.name < location.name })
        }
    }
}
