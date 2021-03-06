//
//  main.swift
//  Example
//
//  Created by Max Reshetey on 20.05.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation
import Algo

func isSorted(arr: Array<Int>) -> Bool {
    for i in 0..<arr.count-1 {
        if arr[i] > arr[i+1] {
            return false
        }
    }
    return true
}

//var arr = Array<Int>(1...10)
//arr.reverse()
//arr.shuffle()
//var arr = [1, 2, 3, 4, 5, 6, 7, 8]
//var arr = [8, 7, 6, 5, 4, 3, 2, 1]
//print("\(arr), sorted: \(isSorted(arr: arr))")
//let before = Date().timeIntervalSince1970
//let after = Date().timeIntervalSince1970
//let duration = after - before
//
//print("\(arr), sorted: \(isSorted(arr: arr))")
//print("Took: \(duration) seconds")

//TrieTests.testAll()
//LMIS.test()
//NaiveStringMatcher_Tests.test()
//RabinKarpMatcher_Tests.test()
//FiniteAutomatonMatcher_Tests.test()
KMPMatcher_Tests.test()
