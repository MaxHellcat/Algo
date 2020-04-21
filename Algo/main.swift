//
//  main.swift
//  Algo
//
//  Created by Max Reshetey on 06.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

func isSorted(arr: Array<Int>) -> Bool {

    for i in 0..<arr.count-1 {
        if arr[i] > arr[i+1] {
            return false
        }
    }

    return true
}

var arr = Array<Int>(1...10)
//arr.reverse()
arr.shuffle()

//print("\(arr), sorted: \(isSorted(arr: arr))")

let before = Date().timeIntervalSince1970

//insertionSort(&arr)
//mergeSort(&arr, 0, arr.count-1)
//quickSort(&arr, 0, arr.count-1)
//heapSort(&arr)

//let i = 7
//let orderStatistic = randomizedSelect(&arr, 0, arr.count-1, i)
//print("The \(i)th order statistic: \(orderStatistic)")
//let orderStatisticIter = randomizedSelectIterative(&arr, 0, arr.count-1, i)
//print("The \(i)th order statistic: \(orderStatisticIter)")

SinglyLinkedList.test()

let after = Date().timeIntervalSince1970
var duration = after - before

//print("\(arr), sorted: \(isSorted(arr: arr))")
print("Took: \(duration) seconds")
