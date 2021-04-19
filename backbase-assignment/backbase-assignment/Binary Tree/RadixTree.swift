//
//  RadixTree.swift
//  backbase-assignment
//
//  Created by ninja on 18/04/2021.
//

import Foundation

class RadixTree {
    var root: RadixNode

    #if DEBUG
    var count = 1
    #endif

    init() {
        root = RadixNode("")
    }

    public func insert(_ location: Location) {
        let key = location.displayName.lowercased()

        if key.isEmpty { return }

        var node = root
        var prefix = key

        while true {
            var found = false

            // Node has no children, create one and attach it
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
                let commonPrefix = (prefix as NSString).commonPrefix(with: child.value)

                // prefix is already in tree
                if prefix == commonPrefix {
                    child.insertLocation(location)
                    return
                }

                // Down the rabbit hole, there's already a child for this prefix - go into the children
                if commonPrefix == child.value {
                    node = child
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))...])
                    found = true
                    break // break out of child search
                }

                // Time to crack this node into two
                if !commonPrefix.isEmpty {
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))...])
                    child.value = String(child.value[child.value.index(child.value.startIndex, offsetBy: (commonPrefix.count))...])

                    let firstChildNode = RadixNode(child.value, children: child.children, parent: child)
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
