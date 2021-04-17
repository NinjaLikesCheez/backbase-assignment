//
//  Node.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

/// A node in a binary tree.
/// - Note: While this could be generic (any hashable will do as the children are in a dictionary) the scope of this project is pretty limited.
class Node {
    /// The node containing this node
    weak var parent: Node?

    /// The children of this node
    var children = [Character: Node]()

    /// The value of this node
    var value: Character?

    // TODO: this doesn't need to be an empty array unless we're storing stuff here.
    /// A list of locations this node can represent
    var locations: Locations?

    /// Does this node terminate the chain of nodes?
    var isTerminationNode = false

    init(_ value: Character? = nil, parent: Node? = nil) {
        self.value = value
        self.parent = parent
    }

    /// Attaches a child node if one doesn't already exist.
    func insert(character: Character) {
        if children[character] == nil {
            children[character] = Node(character, parent: self)
        }
    }
}
