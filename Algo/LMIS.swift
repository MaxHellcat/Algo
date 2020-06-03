//
//  LMIS.swift
//  Algo
//
//  Created by Max Reshetey on 02.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

///
/// Time O(2^n), where n = arr.count
///
func lmisRecursive(_ arr: Array<Int>, _ i: Int) -> Int {

    guard !arr.isEmpty else { return 0 } // Client call precondition

    if i == arr.count-1 {
        return 1 // Non-empty sequence has at least one-element LMIS
    }

    var maxVal = 0

    for j in i+1..<arr.count {

        var val = lmisRecursive(arr, j)

        if arr[i] <= arr[j] {
            val += 1
        }
        maxVal = max(maxVal, val)
    }

    return maxVal
}

///
/// Time O(n^2), where n = arr.count
///
/// Exercise 15.4-5 in CLRS
///
func lmisBottomUp(_ arr: Array<Int>) -> Int {

    guard !arr.isEmpty else { return 0 } // Client call precondition

    var maxVal = 1 // Non-empty sequence has at least one-element LMIS

    var mem = Array<Int>(repeating: 0, count: arr.count)

    for i in 1..<arr.count {

        maxVal = 1

        for j in 0..<i {

            var val = j > 0 ? mem[j-1] : 1

            if arr[j] <= arr[i] {
                val += 1
            }
            maxVal = max(maxVal, val)
        }

        mem[i-1] = maxVal
    }

    return maxVal
}

// LMIS - Longest Monotonically Increasing Subsequence
public enum LMIS {

    public static func test() {

//        let arr = [7, 3, 1, 2, 5, 9, 6, 8, 4] // 1, 2, 5, 6, 8
//        let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
//        let arr = [9, 8, 7, 3, 5, 4, 6, 2, 1]
        let arr: Array<Int> = [1, 1, 1, 1, 1]
//        let arr: Array<Int> = []

        let val1 = lmisRecursive(arr, 0)
        print("Val1: \(val1)")

        let val2 = lmisBottomUp(arr)
        print("Val2: \(val2)")
    }
}
