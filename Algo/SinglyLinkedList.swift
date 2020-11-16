//
//  SinglyLinkedList.swift
//  Algo
//
//  Created by Max Reshetey on 14.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

class SinglyLinkedList<T: Comparable> {

    class Node {

        let key: T
        var next: Node?

        init(key: T) {
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

    func insertFirst(node: Node) {

        precondition(true, "The node must not be in the list")

        node.next = head
        head = node
    }

    func remove(node: Node) {

        if node === head {
            head = node.next
            return
        }

        var prevNode: Node? = nil
        var inode = head
        while inode != nil && inode !== node {
            prevNode = inode
            inode = inode!.next
        }

//        assert(inode != nil, "Node to remove is not in the list!")

        if prevNode != nil {
            prevNode!.next = node.next
        }
    }

    func search(key: T) -> Node? {

        var node = head

        while node != nil && node!.key != key {
            node = node!.next
        }

        return node
    }
}

extension SinglyLinkedList: CustomStringConvertible {

    var description: String {

        var s = "["

        var node = head
        var prev: Node? = nil
        while node != nil {
            if prev != nil {
                s += ", "
            }
            s += "\(node!.key)"
            node = node!.next
            prev = node
        }

        s += "]"

        return s
    }
}

extension SinglyLinkedList.Node: CustomStringConvertible {

    var description: String {
        return "\(key)"
    }
}

public enum TestSinglyLinkedList {

    static func testInsertFirst() {

        let list = SinglyLinkedList<Int>()
        print("List: \(list)")

        for i in 1...10 {
            list.insertFirst(node: SinglyLinkedList<Int>.Node(key: i))
        }
        print("List: \(list)")
    }

    static func testSearch() {

        let list = SinglyLinkedList<Int>()

        for i in 1...10 {
            list.insertFirst(node: SinglyLinkedList<Int>.Node(key: i))
        }
        print("List: \(list)")

        var key = 1837
        print("Search missing node \(key)")
        print("Found: \(String(describing: list.search(key: key)))")

        key = 7
        print("Search existing node \(key)")
        print("Found: \(String(describing: list.search(key: key)))")
    }

    static func testRemoveNode() {

        let list = SinglyLinkedList<Int>()

        for i in 1...10 {
            list.insertFirst(node: SinglyLinkedList<Int>.Node(key: i))
        }
        print("List: \(list)")

        var node = list.search(key: 10)!
        print("Remove head node \(node)")
        list.remove(node: node)
        print("List: \(list)")

        node = list.search(key: 6)!
        print("Remove middle node \(node)")
        list.remove(node: node)
        print("List: \(list)")

        node = list.search(key: 1)!
        print("Remove tail node \(node)")
        list.remove(node: node)
        print("List: \(list)")

        node = SinglyLinkedList<Int>.Node(key: 55)
        print("Remove missing node \(node)")
        list.remove(node: node)
        print("List: \(list)")
    }

    public static func test() {

        testInsertFirst()
        testSearch()
        testRemoveNode()
    }
}
