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

        let q = partition(&arr, p, r)

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
