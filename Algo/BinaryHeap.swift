//
//  BinaryHeap.swift
//  Algo
//
//  Created by Max Reshetey on 19.11.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

protocol Keyable: AnyObject {
    var key: Int { get set }
}

//
// Binary (min/max) heap implementation using arrays
//
class BinaryHeap {

    enum HeapType {
        case min // Property: for every node i other than the root, A[parent(i)] <= A[i]
        case max // Same, but A[parent(i)] >= A[i]
    }

    private class Node: Keyable {
        var key: Int
        init(key: Int) {
            self.key = key
        }
    }

    private let type: HeapType
    private var arr: [Keyable]

    init(type: HeapType, nodes: [Keyable]) {
        self.type = type
        self.arr = nodes
        build()
    }

    init(_ arr: [Int], type: HeapType) {
        self.arr = arr.map{ Node(key: $0) }
        self.type = type
        build()
    }

    // Time O(n)
    func isHeap() -> Bool {

        for i in (0..<arr.count).reversed() {
            if type == .max ? arr[parent(i)].key < arr[i].key : arr[parent(i)].key > arr[i].key {
                return false
            }
        }

        return true
    }

    var count: Int {
        return arr.count
    }

    // Only applicable for min heap
    func extractMin() -> Keyable {

        assert(!arr.isEmpty, "Heap underflow")

        let min = arr[0]

        arr[0] = arr[arr.count-1]
        arr.removeLast()
        heapify(0)

        return min
    }

    // Time O(lgn)
    func decrease(_ i: Int, _ key: Int) {

        var i = i

        if key > arr[i].key {
            assertionFailure("key cannot be larger than current")
            return
        }

        arr[i].key = key

        while i > 0 && arr[parent(i)].key > arr[i].key {
            arr.swapAt(parent(i), i)
            i = parent(i)
        }
    }

    // Only applicable for min heap
    // TODO: This custom search is used by MST_Prim
    // Time O(n) due to linear index search
    func decrease(node: Keyable, key: Int) {

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

        var minMaxIndex: Int
        if type == .max {
            if leftIndex < arr.count && arr[leftIndex].key > arr[index].key {
                minMaxIndex = leftIndex
            }
            else {
                minMaxIndex = index
            }
            if rightIndex < arr.count && arr[rightIndex].key > arr[minMaxIndex].key {
                minMaxIndex = rightIndex
            }
        }
        else {
            if leftIndex < arr.count && arr[leftIndex].key < arr[index].key {
                minMaxIndex = leftIndex
            }
            else {
                minMaxIndex = index
            }
            if rightIndex < arr.count && arr[rightIndex].key < arr[minMaxIndex].key {
                minMaxIndex = rightIndex
            }
        }

        if minMaxIndex != index {
            arr.swapAt(index, minMaxIndex)
            heapify(minMaxIndex)
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

extension BinaryHeap: CustomStringConvertible {

    var description: String {
        return arr.description
    }
}

public enum TestBinaryHeap {

    public static func testAll() {

        print("Test min heap")
        for _ in 1...10 {
            let arr = [Int](1...10).shuffled()
            print("Arry: \(arr)")
            let heap = BinaryHeap(arr, type: .min)
            print("Heap: \(heap)")
            print("isHeap: \(heap.isHeap())")
            assert(heap.isHeap())
        }

        print("Test max heap")
        for _ in 1...10 {
            let arr = [Int](1...10).shuffled()
            print("Arry: \(arr)")
            let heap = BinaryHeap(arr, type: .max)
            print("Heap: \(heap)")
            print("isHeap: \(heap.isHeap())")
            assert(heap.isHeap())
        }
    }
}
