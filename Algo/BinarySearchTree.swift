//
//  BinarySearchTree.swift
//  Algo
//
//  Created by Max Reshetey on 26.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

public class BinarySearchTree {

    public class Node: Equatable, CustomStringConvertible {

        public static func == (lhs: Node, rhs: Node) -> Bool {
             return lhs === rhs
        }
        public var description: String {
            return "(key: \(key))"
        }

        public let key: Int
        public var parent: Node?, left: Node?, right: Node?

        public init(key: Int) {
            self.key = key
        }

        deinit {
            print("Deinit node \(self)")
        }

    }

    public var root: Node?

    public init() {}

    ///
    /// Time O(h)
    ///
    public func insert(node: Node) {

        var parent: Node? = nil
        var tmpNode = root

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
    public func delete(node: Node) {

        if node.left == nil {

            // Left is nil, right may or may not be nil

            print("Left is nil, right may or may not be nil")

            transplant(u: node, v: node.right)
        }
        else if node.right == nil {

            // Right is nil, left is valid

            print("Right is nil, left is valid")

            transplant(u: node, v: node.left)
        }
        else {

            // Right and left are valid

            print("Right and left are valid")

            let minNode = min(node: node.right!)

            if node.right != minNode {

                // Right is not minimum, doing sub-trasnplant first

                print("Right is not minimum, doing sub-transplant first")

                transplant(u: minNode, v: minNode.right)

                minNode.right = node.right
                minNode.right!.parent = minNode
            }

            transplant(u: node, v: minNode)

            minNode.left = node.left
            minNode.left!.parent = minNode
        }
    }

    /// Replaces the subtree rooted at node u with the subtree rooted at node v (v allowed to be nil by design)
    ///
    /// Time O(1)
    ///
    private func transplant(u: Node, v: Node?) {

        if u.parent == nil {
            root = v
        }
        else if u.parent!.left == u {
            u.parent!.left = v
        }
        else {
            u.parent!.right = v
        }

        if v != nil {
            v!.parent = u.parent
        }
    }

    ///
    /// Time O(h)
    ///
    public func search(key: Int) -> Node? {

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

        while tmpParent != nil && tmpParent!.left != tmpNode {
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

        while tmpParent != nil && tmpParent!.right != tmpNode {
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

extension BinarySearchTree {

    // Hint: Use enum TestBinarySearchTree, or the like
    public class func test() {

        let tree = BinarySearchTree()

        for i in Array(1...10).shuffled() {
            tree.insert(node: Node(key: i))
        }

        print("Tree:")
        tree.traverseInOrder(node: tree.root) { print($0.key) }

        print("Min: \(tree.min(node: tree.root!))")
        print("Max: \(tree.max(node: tree.root!))")

        let key = 3
        let node = tree.search(key: key)!
        print("Search \(key): \(String(describing: node))")

        print("Successor of \(key): \(String(describing: tree.successor(node: node)))")
        print("Predecessor of \(key): \(String(describing: tree.predecessor(node: node)))")

        print("Delete node \(node)")
        tree.delete(node: node)

        print("Tree:")
        tree.traverseInOrder(node: tree.root) { print($0.key) }
    }
}
