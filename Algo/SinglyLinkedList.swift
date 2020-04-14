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

    private var head: Node?

    func insert(node: Node) {

        node.next = head
        head = node
    }

    func remove(node: Node) {

        if node === head {
            head = head?.next
            return
        }

        var prevNode = head

        while prevNode != nil && prevNode?.next !== node {
            prevNode = prevNode?.next
        }

        if prevNode != nil {
            prevNode?.next = node.next
        }
    }

    func search(key: Int) -> Node? {

        var node = head

        while node != nil && node?.key != key {
            node = node?.next
        }

        return node
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
