//
//  RandomizedSelect.swift
//  Algo
//
//  Created by Max Reshetey on 09.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time Ø(n^2) - worst, Ø(nlgn) - expected, space O(1)
//
public func randomizedSelect(_ arr: inout Array<Int>, _ p: Int, _ r: Int, _ i: Int) -> Int {

    if p == r {
        return arr[p]
    }

    let q = randomizedPartition(&arr, p, r)

    let k = q - p + 1

    if i == k { // the pivot value is the answer
        return arr[q]
    }
    else if i < k {
        return randomizedSelect(&arr, p, q-1, i)
    }
    else {
        return randomizedSelect(&arr, q+1, r, i-k)
    }
}

//
// Time and space are the same as for randomizedSelect
//
// Exercise 9.2-3 in CLRS
//
public func randomizedSelectIterative(_ arr: inout Array<Int>, _ p: Int, _ r: Int, _ i: Int) -> Int {

    var tmpP = p, tmpR = r, tmpI = i, resultIndex = p

    while tmpP < tmpR {

        let q = randomizedPartition(&arr, tmpP, tmpR)

        let k = q - tmpP + 1

        if tmpI == k { // the pivot value is the answer
            resultIndex = q
            break
        }
        else if tmpI < k {
            tmpR = q - 1
        }
        else {
            tmpP = q + 1
            tmpI -= k
            resultIndex = tmpP
        }
    }

    return arr[resultIndex]
}

enum RandomizedSelectTests {

    // TODO: Add proper tests for this!
    static func testAll() {
        var arr = Array<Int>(1...10)
        let i = 7
        let orderStatistic = randomizedSelect(&arr, 0, arr.count-1, i)
        print("The \(i)th order statistic: \(orderStatistic)")
        let orderStatisticIter = randomizedSelectIterative(&arr, 0, arr.count-1, i)
        print("The \(i)th order statistic: \(orderStatisticIter)")
    }
}
