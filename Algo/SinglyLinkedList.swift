//
//  SinglyLinkedList.swift
//  Algo
//
//  Created by Max Reshetey on 14.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

class SinglyLinkedList {

    class Node {

        let key: Int
        var next: Node?

        init(key: Int) {
            self.key = key
        }

        deinit {
            print("Deinit node \(self)")
        }
    }

    deinit {
        print("Deinit \(self)")
    }

    private(set) var head: Node?

    // Push back if atNode is nil
    func insert(node: Node, atNode: Node?) {

        precondition(true, "The atNode must be in the list")

        if atNode === head { // Nil head is also caught here

            node.next = head
            head = node
        }
        else if let prevNode = searchPrev(node: atNode) {

            node.next = prevNode.next
            prevNode.next = node
        }
        else {

            preconditionFailure("The atNode must be in the list")
        }
    }

    func remove(node: Node) {

        precondition(true, "The node must be in the list")

        if node === head {

            head = node.next
        }
        else if let prevNode = searchPrev(node: node) {

            prevNode.next = node.next
        }
        else {

            preconditionFailure("The node must be in the list")
        }
    }

    func search(key: Int) -> Node? {

        var node = head

        while node != nil && node!.key != key {
            node = node!.next
        }

        return node
    }

    // Returns tail if passed node is nil
    private func searchPrev(node: Node?) -> Node? {

        var prevNode = head

        while prevNode != nil && prevNode!.next !== node {
            prevNode = prevNode!.next
        }

        return prevNode
    }
}

extension SinglyLinkedList {

    class func test() {

        let list = SinglyLinkedList()

        for i in 1...10 {
            list.insert(node: SinglyLinkedList.Node(key: i), atNode: nil)
        }
        print("List: \(list)")

        let key = 7
        print("Search node \(key)")
        weak var node = list.search(key: key)
        print("Found node: \(String(describing: node))")

        let newNode = SinglyLinkedList.Node(key: 25)
        print("Insert node \(newNode) at \(String(describing: node))")
        list.insert(node: newNode, atNode: node)
        print("List: \(list)")

        print("Remove node \(newNode)")
        list.remove(node: newNode)
        print("List: \(list)")
    }
}

extension SinglyLinkedList: CustomStringConvertible {

    var description: String {

        var s = "["

        var node = head
        while node?.next != nil {
            s += "\(node!.key), "
            node = node?.next
        }

        if let node = node {
            s += "\(node.key)]"
        }

        return s
    }
}

extension SinglyLinkedList.Node: CustomStringConvertible {

    var description: String {
        return "(key: \(key))"
    }
}
