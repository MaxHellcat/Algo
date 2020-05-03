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
    /// Time O(h)
    ///
    func delete(node: Node) {

        if node.right == nil {

            // Either right or both are nil

            print("Either right or both are nil")

            transplant(node: node, childNode: node.left)
        }
        else if node.right != nil {

            // Left is nil, right is valid

            print("Left is nil, right is valid")

            let minNode = min(node: node.right!)

            if node.right === minNode {

                // Right is minimum (it has no left)

                print("Right is minimum (it has no left)")

                transplant(node: node, childNode: node.right)
            }
            else {

                // Right is not minimum (it has left)

                print("Right is not minimum (it has left)")

                let tmpMinNode = minNode

                transplant(node: minNode, childNode: minNode.right)

                tmpMinNode.right = node.right
                node.right!.parent = tmpMinNode

                if node.parent != nil {

                    if node.parent!.left === node {
                        node.parent!.left = tmpMinNode
                    }
                    else {
                        node.parent!.right = tmpMinNode
                    }

                    tmpMinNode.parent = node.parent
                }
            }

            if node.left != nil {
                node.left!.parent = minNode
                minNode.left = node.left
            }
        }
    }

    ///
    /// Time O(1)
    ///
    private func transplant(node: Node, childNode: Node?) {

        if node.parent == nil {
            root = childNode
            return
        }

        if node.parent!.left === node {
            node.parent!.left = childNode
        }
        else {
            node.parent!.right = childNode
        }

        if childNode != nil {
            childNode!.parent = node.parent
        }
    }

    ///
    /// Time O(h)
    ///
    func search(node: Node, key: Int) -> Node? {

        var tmpNode = root

        while tmpNode != nil && key != tmpNode!.key {

            if key < tmpNode!.key {
                tmpNode = tmpNode!.left
            }
            else {
                tmpNode = tmpNode!.right
            }
        }

        return tmpNode
    }

    ///
    /// Time O(h)
    ///
    func min(node: Node) -> Node {

        var tmpNode = node

        while tmpNode.left != nil {
            tmpNode = tmpNode.left!
        }

        return tmpNode
    }

    ///
    /// Time O(h)
    ///
    func max(node: Node) -> Node {

        var tmpNode = node

        while tmpNode.right != nil {
            tmpNode = tmpNode.right!
        }

        return tmpNode
    }

    ///
    /// Time O(h)
    ///
    func successor(node: Node) -> Node? {

        if node.right != nil {
            return min(node: node.right!)
        }

        var tmpNode = node
        var tmpParent = tmpNode.parent

        while tmpParent != nil && tmpParent!.left !== tmpNode {
            tmpNode = tmpParent!
            tmpParent = tmpParent!.parent
        }

        return tmpParent
    }

    ///
    /// Time O(h)
    ///
    func predecessor(node: Node) -> Node? {

        if node.left != nil {
            return max(node: node.left!)
        }

        var tmpNode = node
        var tmpParent = tmpNode.parent

        while tmpParent != nil && tmpParent!.right !== tmpNode {
            tmpNode = tmpParent!
            tmpParent = tmpParent!.parent
        }

        return tmpParent
    }

    ///
    /// Time: Ø(n)
    ///
    func traverseInOrder(node: Node?, block: (Node) -> Void) {

        guard let node = node else { return } // Base case

        traverseInOrder(node: node.left, block: block)
        block(node)
        traverseInOrder(node: node.right, block: block)
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

        for i in Array(1...10).shuffled() {
            tree.insert(node: BinarySearchTree.Node(key: i))
        }

        print("Tree:")
        tree.traverseInOrder(node: tree.root) { print($0.key) }

        print("Min: \(tree.min(node: tree.root!))")
        print("Max: \(tree.max(node: tree.root!))")

        let key = 3
        let node = tree.search(node: tree.root!, key: key)!
        print("Search \(key): \(String(describing: node))")

        print("Successor of \(key): \(String(describing: tree.successor(node: node)))")
        print("Predecessor of \(key): \(String(describing: tree.predecessor(node: node)))")

        print("Delete node \(node)")
        tree.delete(node: node)

        print("Tree:")
        tree.traverseInOrder(node: tree.root) { print($0.key) }

    }
}
