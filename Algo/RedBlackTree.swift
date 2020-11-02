//
//  RedBlackTree.swift
//  Algo
//
//  Created by Max Reshetey on 20.05.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

public class RedBlackTree {

    public class Node: Equatable, CustomStringConvertible {

        public static func == (lhs: Node, rhs: Node) -> Bool {
             return lhs === rhs
        }
        public var description: String {
            return "(key: \(key))"
        }

        public enum Color { case red, black }

        public let key: Int
        public var parent: Node!, left: Node!, right: Node!
        public var color: Color

        public static let Nil = Node(key: -1, color: .black)

        public init(key: Int, color: Color = .red) {
            self.key = key
            self.color = color
        }

        deinit {
            print("Deinit node \(self)")
        }
    }

    public var root: Node = Node.Nil

    public init() {}

    deinit {
        print("Deinit RedBlackTree")
    }

    ///
    /// Time O(lgn)
    ///
    public func insert(node: Node) {

        var parent = Node.Nil
        var tmpNode = root

        while tmpNode != Node.Nil {
            parent = tmpNode
            if node.key <= tmpNode.key {
                tmpNode = tmpNode.left
            }
            else {
                tmpNode = tmpNode.right
            }
        }

        node.parent = parent

        if parent == Node.Nil {
            root = node
        }
        else if node.key <= parent.key {
            parent.left = node
        }
        else {
            parent.right = node
        }
        node.left = Node.Nil
        node.right = Node.Nil
        node.color = .red

        insertFixup(node)
    }

    ///
    /// Time O(lgn)
    ///
    private func insertFixup(_ aNode: Node) {

        var node = aNode

        // Each iteration of the loop has two possible outcomes:
        // Either the pointer moves up the tree (case 1)
        // Or we perform some rotations and then the loop terminates (cases 2, 3)
        while node.parent.color == .red {

            if node.parent == node.parent.parent.left {

                let uncle: Node = node.parent.parent.right

                if uncle.color == .red { // CASE 1
                    print("CASE 1")
                    node.parent.color = .black
                    uncle.color = .black
                    node.parent.parent.color = .red
                    node = node.parent.parent
                }
                else {
                    if node == node.parent.right { // CASE 2
                        print("CASE 2")
                        node = node.parent
                        rotateLeft(node)
                    }
                    print("CASE 3")
                    node.parent.color = .black // CASE 3
                    node.parent.parent.color = .red
                    rotateRight(node.parent.parent)
                }
            }
            else { // Symmetric case here `node.parent == node.parent.parent.right`

                let uncle: Node = node.parent.parent.left

                if uncle.color == .red { // CASE 1
                    print("CASE 1")
                    node.parent.color = .black
                    uncle.color = .black
                    node.parent.parent.color = .red
                    node = node.parent.parent
                }
                else {
                    if node == node.parent.left { // CASE 2
                        print("CASE 2")
                        node = node.parent
                        rotateRight(node)
                    }
                    print("CASE 3")
                    node.parent.color = .black // CASE 3
                    node.parent.parent.color = .red
                    rotateLeft(node.parent.parent)
                }
            }
        }
        root.color = .black
    }

    ///
    /// Time O(lgn)
    ///
    public func delete(node: Node) {

        var y = node
        var yOriginalColor = y.color
        let x: Node

        if node.left == Node.Nil {

            // Left is nil, right may or may not be nil
            print("Left is nil, right may or may not be nil")

            x = node.right
            transplant(u: node, v: node.right)
        }
        else if node.right == Node.Nil {

            // Right is nil, left is valid
            print("Right is nil, left is valid")

            x = node.left
            transplant(u: node, v: node.left)
        }
        else {

            // Right and left are valid
            print("Right and left are valid")

            y = min(node: node.right)
            yOriginalColor = y.color
            x = y.right

            if y.parent == node {
                x.parent = y // ?
            }
            else {
                // Right is not minimum, doing sub-trasnplant first
                print("Right is not minimum, doing sub-transplant first")

                transplant(u: y, v: y.right)
                y.right = node.right
                y.right.parent = y
            }

            transplant(u: node, v: y)
            y.left = node.left
            y.left.parent = y
            y.color = node.color
        }

        if yOriginalColor == .black {
            deleteFixup(x)
        }
    }

    ///
    /// Time O(lgn)
    ///
    private func deleteFixup(_ aNode: Node) {

        var node = aNode

        // The goal of the while loop is to move the extra black up the tree
        // Within the while loop, `node` always points to a nonroot doubly black node
        while node != root && node.color == .black {

            if node == node.parent.left {

                print("DIRECT")

                var w: Node = node.parent.right
                if w.color == .red { // CASE 1
                    print("CASE 1")
                    w.color = .black
                    node.parent.color = .red
                    rotateLeft(node.parent)
                    w = node.parent.right
                    // The new sibling of `node`, which is one of w’s children prior to the rotation, is now black, and thus we have converted case 1 into case 2, 3, or 4.
                }
                if w.left.color == .black && w.right.color == .black { // CASE 2
                    print("CASE 2")
                    w.color = .red
                    node = node.parent
                }
                else {
                    if w.right.color == .black { // CASE 3
                        print("CASE 3")
                        w.left.color = .black
                        w.color = .red
                        rotateRight(w)
                        w = node.parent.right
                        // The new sibling w of `node` is now a black node with a red right child, and thus we have transformed case 3 into case 4.
                    }
                    print("CASE 4")
                    w.color = node.parent.color // CASE 4
                    node.parent.color = .black
                    w.right.color = .black
                    rotateLeft(node.parent)
                    node = root
                }
            }
            else { // Symmetric case here `node == node.parent.right`

                print("SYMMETRIC")

                var w: Node = node.parent.left
                if w.color == .red { // CASE 1
                    print("CASE 1")
                    w.color = .black
                    node.parent.color = .red
                    rotateRight(node.parent)
                    w = node.parent.left
                }
                if w.left.color == .black && w.right.color == .black { // CASE 2
                    print("CASE 2")
                    w.color = .red
                    node = node.parent
                }
                else {
                    if w.left.color == .black { // CASE 3
                        print("CASE 3")
                        w.right.color = .black
                        w.color = .red
                        rotateLeft(w)
                        w = node.parent.left
                    }
                    print("CASE 4")
                    w.color = node.parent.color // CASE 4
                    node.parent.color = .black
                    w.left.color = .black
                    rotateRight(node.parent)
                    node = root
                }
            }
        }
        node.color = .black
    }

    ///
    /// Time O(1)
    ///
    private func transplant(u: Node, v: Node) {

        if u.parent == Node.Nil {
            root = v
        }
        else if u.parent.left == u {
            u.parent.left = v
        }
        else {
            u.parent.right = v
        }
        v.parent = u.parent
    }

    ///
    /// Time O(1)
    ///
    private func rotateLeft(_ x: Node) {

        assert(x.right != Node.Nil)
        assert(root.parent == Node.Nil)

        let y: Node = x.right
        x.right = y.left
        if y.left != Node.Nil {
            y.left.parent = x
        }
        y.parent = x.parent
        if x.parent == Node.Nil {
            root = y
        }
        else if x == x.parent.left {
            x.parent.left = y
        }
        else {
            x.parent.right = y
        }
        y.left = x
        x.parent = y
    }

    ///
    /// Time O(1)
    ///
    private func rotateRight(_ x: Node) {

        assert(x.left != Node.Nil)
        assert(root.parent == Node.Nil)

        let y: Node = x.left
        x.left = y.right
        if y.right != Node.Nil {
            y.right.parent = x
        }
        y.parent = x.parent
        if x.parent == Node.Nil {
            root = y
        }
        else if x == x.parent.left {
            x.parent.left = y
        }
        else {
            x.parent.right = y
        }
        y.right = x
        x.parent = y
    }

    ///
    /// Time O(lgn)
    ///
    public func search(key: Int) -> Node? {

        var tmpNode = root

        while tmpNode != Node.Nil && key != tmpNode.key {

            if key < tmpNode.key {
                tmpNode = tmpNode.left
            }
            else {
                tmpNode = tmpNode.right
            }
        }

        return tmpNode
    }


    ///
    /// Time O(lgn)
    ///
    func min(node: Node) -> Node {

        var tmpNode = node

        while tmpNode.left != Node.Nil {
            tmpNode = tmpNode.left
        }

        return tmpNode
    }

    ///
    /// Time O(lgn)
    ///
    func max(node: Node) -> Node {

        var tmpNode = node

        while tmpNode.right != Node.Nil {
            tmpNode = tmpNode.right
        }

        return tmpNode
    }

    ///
    /// Time: Ø(n)
    ///
    func traverseInOrder(node: Node, block: (Node) -> Void) {

        if node == Node.Nil { return } // Base case

        traverseInOrder(node: node.left, block: block)
        block(node)
        traverseInOrder(node: node.right, block: block)
    }
}

extension RedBlackTree {

    public class func test() {

        let tree = RedBlackTree()

        for i in Array(1...10) {
            tree.insert(node: Node(key: i))
        }

        print("RedBlackTree:")
        tree.traverseInOrder(node: tree.root) { print($0.key) }

        print("Min: \(tree.min(node: tree.root))")
        print("Max: \(tree.max(node: tree.root))")
    }
}
