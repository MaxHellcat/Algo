//
//  HeapSort.swift
//  Algo
//
//  Created by Max Reshetey on 08.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time O(nlgn), space O(1)
//
public func heapSort(_ arr: inout Array<Int>) {

    var maxHeap = MaxHeap()

    maxHeap.build(&arr)

    while maxHeap.count > 1 {

        arr.swapAt(0, maxHeap.count-1)
        maxHeap.count -= 1
        maxHeap.heapify(&arr, 0)
    }
}

struct MaxHeap {

    // Note, we don't store array to avoid deep copying
    var count: Int = 0

    func left(_ index: Int) -> Int {
        return 2*index + 1
    }

    func right(_ index: Int) -> Int {
        return 2*index + 2
    }

    func parent(_ index: Int) -> Int {
        return (index-1) / 2
    }

    mutating func build(_ arr: inout Array<Int>) {

        count = arr.count

        for i in (0..<count/2).reversed() {
            heapify(&arr, i)
        }
    }

    mutating func heapify(_ arr: inout Array<Int>, _ index: Int) {

        guard index < count else { return }

        let leftIndex = left(index)
        let rightIndex = right(index)

        var maxIndex: Int

        if leftIndex < count && arr[leftIndex] > arr[index] {
            maxIndex = leftIndex
        }
        else {
            maxIndex = index
        }

        if rightIndex < count && arr[rightIndex] > arr[maxIndex] {
            maxIndex = rightIndex
        }

        if maxIndex != index {
            arr.swapAt(index, maxIndex)
            heapify(&arr, maxIndex)
        }
    }
}
