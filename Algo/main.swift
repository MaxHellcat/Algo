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

var arr = Array<Int>(1...1000)
arr.shuffle()

print("\(arr), sorted: \(isSorted(arr: arr))")

let before = Date().timeIntervalSince1970

//insertionSort(&arr)
//mergeSort(&arr, 0, arr.count-1)
quickSort(&arr, 0, arr.count-1)

let after = Date().timeIntervalSince1970
var duration = after - before

print("\(arr), sorted: \(isSorted(arr: arr))")
print("Took: \(duration) seconds")
