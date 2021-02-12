//
//  MergeSort.swift
//  Algo
//
//  Created by Max Reshetey on 07.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time Ø(nlgn), space O(n)
//
public func mergeSort(_ arr: inout Array<Int>, _ p: Int, _ r: Int) {

    if p < r {

        let q: Int = (p + r) / 2

        mergeSort(&arr, p, q)
        mergeSort(&arr, q+1, r)

        merge(&arr, p, q, r)
    }
}

func merge(_ arr: inout Array<Int>, _ p: Int, _ q: Int, _ r: Int) {

    let leftSize = q-p+1
    var leftArr = Array<Int>(repeating: 0, count: leftSize)
    for i in 0..<leftSize {
        leftArr[i] = arr[i+p]
    }

    let rightSize = r-q
    var rightArr = Array<Int>(repeating: 0, count: rightSize)
    for i in 0..<rightSize {
        rightArr[i] = arr[i+q+1]
    }

    var leftIndex = 0, rightIndex = 0
    for i in p...r {
        if leftIndex < leftSize && rightIndex < rightSize {
            if leftArr[leftIndex] <= rightArr[rightIndex] {
                arr[i] = leftArr[leftIndex]
                leftIndex += 1
            }
            else {
                arr[i] = rightArr[rightIndex]
                rightIndex += 1
            }
        }
        else if leftIndex < leftSize {
            arr[i] = leftArr[leftIndex]
            leftIndex += 1
        }
        else { // if rightIndex == rightSize {
            break ; // Remaining right is already there
        }
    }
}
