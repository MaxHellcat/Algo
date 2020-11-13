//
//  SinglyLinkedList.swift
//  Algo
//
//  Created by Max Reshetey on 14.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

public class SinglyLinkedList<T: Comparable> {

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

        if inode != nil && prevNode != nil {
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

    public var description: String {

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
        return "\(key)"
    }
}

public enum TestSinglyLinkedList {

    public static func test() {

        let list = SinglyLinkedList<Int>()

        for i in 1...10 {
            list.insertFirst(node: SinglyLinkedList<Int>.Node(key: i))
        }
        print("List: \(list)")

        let key = 7
        print("Search node \(key)")
        let findNode = list.search(key: key)
        print("Found node: \(String(describing: findNode))")

        let removeNode = list.search(key: 8)!
//        let removeNode = SinglyLinkedList<Int>.Node(key: 15)
        print("Remove node \(removeNode)")
        list.remove(node: removeNode)
        print("List: \(list)")
    }
}
