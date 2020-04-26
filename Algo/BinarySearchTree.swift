//
//  BinarySearchTree.swift
//  Algo
//
//  Created by Max Reshetey on 26.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

class BinarySearchTree {

    class Node {

        let key: Int
        var parent: Node?, left: Node?, right: Node?

        init(key: Int) {
            self.key = key
        }

        deinit {
            print("Deinit node \(self)")
        }
    }

    var root: Node?

    ///
    /// Time O(h)
    ///
    func insert(node: Node) {

        var tmpNode = root
        var parent: Node? = nil

        while tmpNode != nil {

            parent = tmpNode

            if node.key <= tmpNode!.key {
                tmpNode = tmpNode!.left
            }
            else {
                tmpNode = tmpNode!.right
            }
        }

        if parent == nil {

            root = node
        }
        else {

            if node.key <= parent!.key {
                parent!.left = node
            }
            else {
                parent!.right = node
            }

            node.parent = parent
        }
    }

    ///
    /// Time: Ø(n)
    ///
    func traverseInOrder(node: Node?, block: (Node) -> Void) {

        if node == nil {
            return
        }

        traverseInOrder(node: node!.left, block: block)
        block(node!)
        traverseInOrder(node: node!.right, block: block)
    }
}

extension BinarySearchTree.Node: CustomStringConvertible {

    var description: String {
        return "(key: \(key))"
    }
}

extension BinarySearchTree {

    class func test() {

        let tree = BinarySearchTree()

//        tree.insert(node: Node(key: 7))
//        tree.insert(node: Node(key: 3))
//        tree.insert(node: Node(key: 5))

        for i in Array(1...10).shuffled() {
            tree.insert(node: BinarySearchTree.Node(key: i))
        }

        print("Tree:")
        tree.traverseInOrder(node: tree.root) { print($0.key) }
    }
}
