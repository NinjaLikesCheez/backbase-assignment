//
//  BinaryTree.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import Foundation

/// A light-weight Prefix Binary Search Tree (Trie).
///
/// - Note: While this could be made generic, the scope of this application is pretty small.
class SearchTree {
    /// The top-level node that contains all other nodes
    var root = Node()

    #if DEBUG
    /// The number of nodes in the tree
    var count = 1
    #endif

    /// Inserts a location into the tree
    ///
    /// This will create (if the node doesn't already exist) a node for every character in the location's key until it reaches the end of the key.
    /// When it hits the end of the key, it will attach the location to the terminating node.
    /// - Parameter location: the location to insert
    public func insert(_ location: Location) {
        var node = root

        let key = location.getKey().normalizeForSearch()
        for i in 0...(key.count - 1) {
            let char = key[key.index(key.startIndex, offsetBy: i)]

            if let child = node.children[char] {
                node = child
            } else {
                #if DEBUG
                count += 1
                #endif
                node.insert(character: char)
                node = node.children[char]!
            }

            if i == (key.count - 1) {
                node.isTerminationNode = true

                if node.locations == nil {
                    node.locations = [location]
                } else {
                    node.locations!.append(location)
                }
            }
        }
    }

    /// Searches the tree for a key
    ///
    /// Note: This is a prefix search only, and will operate on a normalized string
    /// - Parameter key: the key to normalize and search for
    /// - Returns: the
    public func search(_ key: String) -> Node {
        var node = root
        let normalizedKey = key.normalizeForSearch()

        // No searchable string, return an 'empty' node set
        if normalizedKey.isEmpty { return Node() }

        for i in 0...(normalizedKey.count - 1) {
            let char = normalizedKey[normalizedKey.index(normalizedKey.startIndex, offsetBy: i)]

            if node.children[char] == nil {
                // There's no more searchable nodes in this tree, return empty node set
                return Node()
            }

            node = node.children[char]!
        }

        return node
    }

    /// Gets a list of `Location` objects from a node
    ///
    /// This will recursively search through childrens, and extract the `Location` objects from terminaing nodes
    /// - Parameter node: the node to search
    /// - Returns: all locations in the subtree
    public func getReachingLocationsFromNode(_ node: Node) -> Locations {
        var results: Locations

        if node.isTerminationNode, let locations = node.locations {
            results = locations
        } else {
            var nodes: [Node] = []
            getReachingTerminationNodes(node, results: &nodes)
            results = nodes.compactMap { $0.locations }.flatMap { $0 }
        }

        return results
    }

    /// Gets all 'terminating' nodes (i.e. the end-of-the-chain nodes)
    /// - Parameters:
    ///   - node: the node to search through
    ///   - results: a list of the terminating nodes
    private func getReachingTerminationNodes(_ node: Node, results: inout [Node]) {
        for child in node.children {
            if child.value.isTerminationNode {
                results.append(child.value)
            }

            getReachingTerminationNodes(child.value, results: &results)
        }
    }
}
