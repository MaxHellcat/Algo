//
//  DisjointSet.swift
//  Algo
//
//  Created by Max Reshetey on 16.11.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// A disjoint-set DS implementation using linked lists (CLRS 21.2)
//
// Differences:
// We use backRefs map to store the owning-set reference for each object, this allows
// to keep an object as a simple `Hashable` value, which we use in Graph implemetation.
// This shouldn't affect the running time for union(x,y), as map[x] amortized access is constant.
class DisjointSet<T: Hashable> {

    class List {
        class Node {
            let key: T
            var next: Node?
            init(key: T) {
                self.key = key
            }
        }
        var head: Node?
        var tail: Node?
        func insertFirst(node: Node) {
            if head == nil {
                tail = node
            }
            node.next = head
            head = node
        }
        deinit {
            print("Deinit list \(self)")
        }
    }

    private(set) var backRefs = [T:List]() // An alternative to object back references
    private(set) var lists = [List]() // Only to log entire disjoint set

    deinit {
        print("Deinit disjoint set")
    }

    func makeSet(x: T) {

        let list = List()
        list.insertFirst(node: List.Node(key: x))
        backRefs[x] = list

        lists.append(list)
    }

    func findSet(x: T) -> List.Node? {
        return backRefs[x]?.head // Return representative
    }

    // TODO: Running time and implementation details
    func union(x: T, y: T) {

        guard let xList = backRefs[x], let yList = backRefs[y] else {
            assertionFailure("x or/and y not in disjoint set")
            return
        }

        var node: List.Node? = yList.head
        while node != nil {
            backRefs[node!.key] = xList
            node = node!.next
        }

        xList.tail?.next = yList.head
        xList.tail = yList.tail

        if let index = lists.firstIndex(where: {$0 === yList}) {
            lists.remove(at: index)
        }
        else {
            assertionFailure()
        }

        // The yList is only held by so-named variable and will be deallocated upon leaving
    }
}

extension DisjointSet: CustomStringConvertible {

    var description: String {
        return lists.description
    }
}

extension DisjointSet.List: CustomStringConvertible {

    var description: String {
        var result = "["
        var node = head
        var prev: Node? = nil
        while node != nil {
            if prev != nil {
                result += ", "
            }
            result += "\(node!.key)"
            node = node!.next
            prev = node
        }
        return result + "]"
    }
}

public enum TestDisjointSet {

    static func testMakeSet() {

        let set = DisjointSet<Int>()
        print("DSet: \(set)")
        for i in 1...5 {
            set.makeSet(x: i)
        }
        print("DSet: \(set)")
    }

    static func testFindSetAndUnion() {

        let set = DisjointSet<Int>()
        print("DSet: \(set)")
        for i in 1...8 {
            set.makeSet(x: i)
        }
        print("DSet: \(set)")
        assert(set.findSet(x: 1) !== set.findSet(x: 2))
        assert(set.findSet(x: 1) !== set.findSet(x: 3))

        for i in stride(from: 1, to: 8, by: 2) {
            set.union(x: i, y: i+1)
        }
        print("DSet: \(set)")
        assert(set.findSet(x: 1) === set.findSet(x: 2))
        assert(set.findSet(x: 1) !== set.findSet(x: 3))

        for i in stride(from: 1, to: 8, by: 4) {
            set.union(x: i, y: i+2)
        }
        print("DSet: \(set)")
        assert(set.findSet(x: 1) === set.findSet(x: 3))
        assert(set.findSet(x: 1) !== set.findSet(x: 5))

        for i in stride(from: 1, to: 8, by: 8) {
            set.union(x: i, y: i+4)
        }
        print("DSet: \(set)")
        assert(set.findSet(x: 1) === set.findSet(x: 5))
    }

    public static func testAll() {

        testMakeSet()
        testFindSetAndUnion()
    }
}
