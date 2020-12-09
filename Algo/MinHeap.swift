//
//  MinHeap.swift
//  Algo
//
//  Created by Max Reshetey on 19.11.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

protocol Keyable: AnyObject {
    var key: Int { get set }
}

// TODO: Split on pure Heap with indices and PriorityQueue with objects
//
// Binary min heap implementation using arrays
//
class MinHeap<T: Keyable> {

    class Node: CustomStringConvertible {
        let object: T
        init(object: T) {
            self.object = object
        }
        var description: String {
            return object.key.description
        }
    }

    private var arr: [Node]

    init(nodes: [Node]) {
        self.arr = nodes
        build()
    }

    // Time O(n)
    func isMinHeap() -> Bool {

        for i in (0..<arr.count).reversed() {
            if arr[parent(i)].object.key > arr[i].object.key {
                return false
            }
        }

        return true
    }

    var isEmpty: Bool {
        return arr.isEmpty
    }

    // Time O(lgn)
    func extractMin() -> T {

        assert(!arr.isEmpty, "Heap underflow")

        let min = arr[0]

        arr[0] = arr[arr.count-1]
        arr.removeLast()
        heapify(0)

        return min.object
    }

    // Time O(lgn)
    func decrease(_ i: Int, _ key: Int) {

        if key > arr[i].object.key {
            assertionFailure("key cannot be larger than current")
            return
        }

        arr[i].object.key = key

        var i = i
        while i > 0 && arr[parent(i)].object.key > arr[i].object.key {
            arr.swapAt(parent(i), i)
            i = parent(i)
        }
    }

    // Extended decrease() to accept Node, not index (Prim's algorithm)
    // Time O(n) due to linear index search
    func decrease(node: Node, key: Int) {

        guard let i = arr.firstIndex(where: {$0 === node}) else {
            assertionFailure("node not in heap")
            return
        }

        decrease(i, key)
    }

    // Time O(n)
    private func build() {

        for i in (0..<arr.count/2).reversed() {
            heapify(i)
        }
    }

    // Time O(lgn)
    private func heapify(_ index: Int) {

        let leftIndex = left(index)
        let rightIndex = right(index)

        var minIndex: Int
        if leftIndex < arr.count && arr[leftIndex].object.key < arr[index].object.key {
            minIndex = leftIndex
        }
        else {
            minIndex = index
        }
        if rightIndex < arr.count && arr[rightIndex].object.key < arr[minIndex].object.key {
            minIndex = rightIndex
        }

        if minIndex != index {
            arr.swapAt(index, minIndex)
            heapify(minIndex)
        }
    }

    private func left(_ index: Int) -> Int {
        return 2*index + 1
    }

    private func right(_ index: Int) -> Int {
        return 2*index + 2
    }

    private func parent(_ index: Int) -> Int {
        return (index-1) / 2
    }
}

extension MinHeap: CustomStringConvertible {
    var description: String {
        return arr.description
    }
}

public enum TestBinaryHeap {

    public static func testAll() {

        class Object: Keyable {
            var key: Int
            init(key: Int) {
                self.key = key
            }
        }

        print("Test min heap")
        for _ in 1...10 {
            let arr = [Int](1...10).shuffled()
            print("Arry: \(arr)")
            let heap = MinHeap(nodes: arr.map{MinHeap.Node(object: Object(key: $0))})
            print("Heap: \(heap)")
            print("isHeap: \(heap.isMinHeap())")
            assert(heap.isMinHeap())
        }
    }
}
