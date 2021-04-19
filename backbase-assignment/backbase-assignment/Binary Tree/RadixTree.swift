//
//  RadixTree.swift
//  backbase-assignment
//
//  Created by ninja on 18/04/2021.
//

import Foundation

class RadixNode {
    weak var parent: RadixNode?
    var children: [RadixNode]
    var value: String

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
}

class RadixTree {
    var root: RadixNode

    init() {
        root = RadixNode("")
    }

    public func insert(_ location: Location) {
        // TODO: Attach locations to terminations nodes
        // TODO: Optimizations - insert in sorted order so we can stop sorting
        let key = location.displayName.lowercased()
        print("inserting: \(key)")

        if key.isEmpty { return }

        var node = root
        var prefix = key
        var found = false

        while !found {
            // Node has no children, create one and attach it
            if node.children.isEmpty {
                let child = RadixNode(prefix, parent: node)
                node.children.append(child)
                return
            }

            for child in node.children {
                let commonPrefix = (prefix as NSString).commonPrefix(with: child.value)

                // prefix is already in tree
                if prefix == commonPrefix { return }

                // Down the rabbit hole, there's already a child for this prefix - go into the children
                if commonPrefix == child.value {
                    node = child
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))])
                    found = true
                    break // break out of child search
                }

                // Time to crack this node into two
                if !commonPrefix.isEmpty {
                    prefix = String(prefix[prefix.index(prefix.startIndex, offsetBy: (commonPrefix.count))...])
                    child.value = String(child.value[child.value.index(child.value.startIndex, offsetBy: (commonPrefix.count))...])

                    child.children.removeAll()
                    let firstChildNode = RadixNode(child.value, children: child.children, parent: child)
                    let secondChildNode = RadixNode(prefix, parent: child)

                    child.value = commonPrefix
                    child.children.append(firstChildNode)
                    child.children.append(secondChildNode)

                    return
                }
            }

            // New child is needed as the prefix doesn't match
            if !found {
                let newChild = RadixNode(prefix, parent: node)
                node.children.append(newChild)
                return
            }
        }
    }
}
