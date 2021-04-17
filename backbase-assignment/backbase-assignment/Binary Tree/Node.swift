//
//  Node.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

// This _could_ be generic, but the scope of this project is pretty limited
class Node {
    weak var parent: Node?
    var children = [Character: Node]()
    var value: Character?
    var locations: Locations = []
    var isTerminationNode = false

    init(_ value: Character? = nil, parent: Node? = nil, locations: Locations? = nil) {
        self.value = value
        self.parent = parent
        if let locations = locations {
            self.locations.append(contentsOf: locations)
        }
    }

    /// Attaches a child node if one doesn't already exist.
    func insert(character: Character) {
        if children[character] == nil {
            children[character] = Node(character, parent: self)
        }
    }
}
