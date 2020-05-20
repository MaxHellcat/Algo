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

    public var root: Node

    public init() {
        root = Node.Nil
    }

    deinit {
        print("Deinit RedBlackTree")
    }

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

    private func insertFixup(_ aNode: Node) {

        var node = aNode

        while node.parent.color == .red {

            if node.parent == node.parent.parent.left {

                let uncle: Node = node.parent.parent.right

                if uncle.color == .red {
                    node.parent.color = .black
                    uncle.color = .black
                    node.parent.parent.color = .red
                    node = node.parent.parent
                }
                else {
                    if node == node.parent.right {
                        node = node.parent
                        rotateLeft(node)
                    }
                    node.parent.color = .black
                    node.parent.parent.color = .red
                    rotateRight(node.parent.parent)
                }
            }
            else { // Here node.parent == node.parent.parent.right

                let uncle: Node = node.parent.parent.left

                if uncle.color == .red {
                    node.parent.color = .black
                    uncle.color = .black
                    node.parent.parent.color = .red
                    node = node.parent.parent
                }
                else {
                    if node == node.parent.left {
                        node = node.parent
                        rotateRight(node)
                    }
                    node.parent.color = .black
                    node.parent.parent.color = .red
                    rotateLeft(node.parent.parent)
                }
            }
        }
        root.color = .black
    }

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
    /// Time O(h)
    ///
    func min(node: Node) -> Node {

        var tmpNode = node

        while tmpNode.left != Node.Nil {
            tmpNode = tmpNode.left
        }

        return tmpNode
    }

    ///
    /// Time O(h)
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
