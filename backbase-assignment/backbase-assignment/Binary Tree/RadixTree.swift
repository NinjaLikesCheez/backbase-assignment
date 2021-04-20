//
//  RadixTree.swift
//  backbase-assignment
//
//  Created by ninja on 18/04/2021.
//

import Foundation

/// A Radix-style binary search tree
class RadixTree {
    /// The 'matriarch' of the tree (i.e. the head of the tree)
    var root: RadixNode

    #if DEBUG
    /// The number of nodes in this tree - useful for debugging tree sizes
    var count = 1
    #endif

    init() {
        root = RadixNode("")
    }

    /// Inserts a location into the tree, using the display name as the key
    public func insert(_ location: Location) {
        let key = location.displayName.lowercased()
        if key.isEmpty { return }

        // the active node we're inspecting
        var node = root
        // as we parse through the tree, this will become shorter as we find common prefixes with other nodes
        // essentially, it represents the unprocessed parts of the key
        var prefix = key

        while true {
            var found = false

            // Node has no children, create a child and attach it to the current node
            if node.children.isEmpty {
                let child = RadixNode(prefix, parent: node)
                child.insertLocation(location)
                node.insertChild(child)

                #if DEBUG
                count += 1
                #endif

                return
            }

            for child in node.children {
                // i.e. 'aachen' & 'aach' have 'aach' as the common prefix
                let commonPrefix = (prefix as NSString).commonPrefix(with: child.value)

                // prefix is already in tree
                if prefix == commonPrefix {
                    child.insertLocation(location)
                    return
                }

                // The child matches the prefix we're looking for, recurse into the children to find the next match
                if commonPrefix == child.value {
                    node = child
                    // Drop the common prefix from the rest prefix string
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))...])
                    found = true
                    break // break out of child search, not the while loop
                }

                // Here, we have a common prefix that doesn't exactly match the child but isn't empty
                // We need to crack the node into two, and attach those two nodes to the current node (updating it's prefix)
                // and locations
                if !commonPrefix.isEmpty {
                    // Get the updated prefix to use for the 'second' child
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))...])
                    // Get the prefix for the 'first' child
                    let firstChildValue = String(child.value[child.value.index(child.value.startIndex, offsetBy: (commonPrefix.count))...])

                    // Create the 'first' node, this is a near replica of the current node, with the updated prefix
                    let firstChildNode = RadixNode(firstChildValue, children: child.children, parent: child)
                    child.children.removeAll()

                    let secondChildNode = RadixNode(prefix, parent: child)

                    // Move locations from the child node to the first node
                    firstChildNode.insertLocations(child.locations)
                    // Create the current location in the second node
                    secondChildNode.insertLocation(location)
                    // nil out the locations on the child node
                    child.locations = nil

                    child.value = commonPrefix
                    child.insertChild(firstChildNode)
                    child.insertChild(secondChildNode)

                    #if DEBUG
                    count += 2
                    #endif

                    return
                }
            }

            // New child is needed as the prefix doesn't match
            if !found {
                let newChild = RadixNode(prefix, parent: node)
                newChild.insertLocation(location)
                node.insertChild(newChild)

                #if DEBUG
                count += 1
                #endif

                return
            }
        }
    }

    /// Searches a tree for a key, returning the node that represents the key
    public func search(_ key: String) -> RadixNode {
        if key.isEmpty { return RadixNode("") }

        var node = root
        var prefix = key.lowercased()

        while true {
            var found = false

            for child in node.children {
                // found an exact match
                if prefix == child.value { return child }

                let commonPrefix = (prefix as NSString).commonPrefix(with: child.value)

                // found a child that matches the commonPrefix
                if commonPrefix == child.value {
                    node = child
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))...])
                    found = true
                    break // break out of child search
                }

                // Guard against empty commonPrefix here as we want to recurse onto the next child (if avaliable)
                if commonPrefix.isEmpty { continue }
                if commonPrefix == prefix { return child }

                // Do a partial match on the child value
                if child.value.starts(with: prefix) {
                    return child
                }
            }

            if !found {
                return RadixNode("")
            }
        }
    }
}

extension RadixTree {
    /// Gets a list of locations for a given node
    /// - Note: if the node has locations, those will be returned. Otherwise, we will do a postfix traversal of the node's children getting all locations
    public func getReachingLocationsFromNode(_ node: RadixNode) -> Locations {
        var results: Locations

        if let locations = node.locations {
            results = locations
        } else {
            var nodes: [RadixNode] = []
            getReachingTerminationNodes(node, results: &nodes)
            results = nodes.compactMap { $0.locations }.flatMap { $0 }
        }

        return results
    }

    /// Gets all 'terminating' nodes (i.e. the end-of-the-chain nodes)
    /// - Parameters:
    ///   - node: the node to search through
    ///   - results: a list of the terminating nodes
    private func getReachingTerminationNodes(_ node: RadixNode, results: inout [RadixNode]) {
        for child in node.children {
            if child.locations != nil && child.children.isEmpty {
                results.append(child)
            }

            getReachingTerminationNodes(child, results: &results)
        }
    }
}
