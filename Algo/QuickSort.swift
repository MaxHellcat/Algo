//
//  QuickSort.swift
//  Algo
//
//  Created by Max Reshetey on 07.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time O(n^2), space O(1)
//
func quickSort(_ arr: inout Array<Int>, _ p: Int, _ r: Int) {

    if p < r {

        let q = randomizedPartition(&arr, p, r)

        quickSort(&arr, p, q-1)
        quickSort(&arr, q+1, r)
    }
}

func partition(_ arr: inout Array<Int>, _ p: Int, _ r: Int) -> Int {

    let pivot = arr[r]
    var i = p-1

    for j in p..<r {

        if arr[j] <= pivot {
            i += 1
            arr.swapAt(j, i)
        }
    }

    arr.swapAt(i+1, r)

    return i+1
}

func randomizedPartition(_ arr: inout Array<Int>, _ p: Int, _ r: Int) -> Int {

    let index = Int.random(in: p...r) // Caveat: Be careful here to not select in 0..<arr.count

    arr.swapAt(index, r)

    return partition(&arr, p, r)
}
