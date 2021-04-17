//
//  BinaryTree.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

class SearchTree {
    var root = Node()

    public func insert(_ location: Location) {
        var node = root

        let key = location.getKey()
        for i in 0...(key.count - 1) {
            let char = key[key.index(key.startIndex, offsetBy: i)]

            if let child = node.children[char] {
                node = child
            } else {
                node.insert(character: char)
                node = node.children[char]!
            }

            if i == (key.count - 1) {
                node.isTerminationNode = true
                node.locations.append(location)
            }
        }
    }

    public func search(_ key: String) -> Node {
        // No searchable string, return an 'empty' node set
        if key.isEmpty { return Node() }

        var node = root
        let lowercasedKey = key.lowercased().filter { $0.isLetter || $0.isNumber }

        for i in 0...(lowercasedKey.count - 1) {
            let char = lowercasedKey[lowercasedKey.index(lowercasedKey.startIndex, offsetBy: i)]

            if node.children[char] == nil {
                // There's no more searchable nodes in this tree, return empty node set
                return Node()
            }

            node = node.children[char]!
        }

        return node
    }

    public func getReachingLocationsFromNode(_ node: Node) -> Locations {
        var results: [Node] = []
        getReachingTerminationNodes(node, results: &results)

        let locations = results.flatMap({ $0.locations })
        return locations
    }

    public func getReachingTerminationNodes(_ node: Node, results: inout [Node]) {
        if node.isTerminationNode {
            results.append(node)
            return
        }

        for child in node.children {
            if child.value.isTerminationNode {
                results.append(child.value)
            }

            getReachingTerminationNodes(child.value, results: &results)
        }
    }

    // TODO: remove this, it's for debugging 
    public func countTree(_ node: Node, result: inout Int) {
        for child in node.children {
            result += 1

            countTree(child.value, result: &result)
        }
    }
}
