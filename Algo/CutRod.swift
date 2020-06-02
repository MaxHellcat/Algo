//
//  CutRod.swift
//  Algo
//
//  Created by Max Reshetey on 28.05.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

///
/// Time O(2^n)
///
func cutRodRecursive(_ prices: Array<Int>, _ n: Int) -> Int {

    if n == 0 {
        return 0
    }

    var q = Int.min

    for i in 1...n {
        q = max(q, prices[i-1] + cutRodRecursive(prices, n-i))
    }

    return q
}

///
/// Time O(n^2)
///
func cutRodTopDown(_ prices: Array<Int>, _ n: Int) -> Int {

    var mem = Dictionary<Int,Int>()

    return cutRodTopDownAux(prices, n, &mem)
}

func cutRodTopDownAux(_ prices: Array<Int>, _ n: Int, _ mem: inout Dictionary<Int,Int>) -> Int {

    if let val = mem[n] {
        return val
    }

    if n == 0 {
        return 0
    }

    var q = Int.min

    for i in 1...n {
        q = max(q, prices[i-1] + cutRodTopDownAux(prices, n-i, &mem))
    }

    mem[n] = q

    return q
}

///
/// Time O(n^2)
///
func cutRodBottomUp(_ prices: Array<Int>, _ n: Int) -> Int {

    var mem = Array<Int>(repeating: 0, count: prices.count+1)

    var q = Int.min

    for j in 1...n {
        for i in 1...j {
            q = max(q, prices[i-1] + mem[j-i])
        }
        mem[j] = q
    }

    return q
}

///
/// Time O(n^2)
///
func cutRodBottomUpExtended(_ prices: Array<Int>, _ n: Int) -> (Int, Array<Int>) {

    var mem = Array<Int>(repeating: 0, count: prices.count+1)
    var rodSizes = Array<Int>(repeating: 0, count: prices.count)

    var q = Int.min

    for j in 1...n {
        for i in 1...j {
            if q < prices[i-1] + mem[j-i] {
                q = prices[i-1] + mem[j-i]
                rodSizes[j-1] = i
            }
        }
        mem[j] = q
    }

    return (q, rodSizes)
}

public enum CutRod {

    public static func test() {

//        let prices = [1, 5, 8, 9, 10, 17, 17, 20, 24, 30]
//        let prices = [1, 5, 8, 9]
        let prices = [1, 5, 8, 9, 10, 17, 17, 20, 24, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 41, 42, 43, 44]

//        let maxRevenue = cutRodRecursive(prices, prices.count)
//        let maxRevenue = cutRodTopDown(prices, prices.count)
//        let maxRevenue = cutRodBottomUp(prices, prices.count)
//        print("Max revenue: \(maxRevenue)")

        let (maxRevenue, rodSizes) = cutRodBottomUpExtended(prices, prices.count)
        print("Max revenue: \(maxRevenue)")
        print("Rod sizes arr: \(rodSizes)")

        var n = prices.count-1
        while n >= 0 {
            print(rodSizes[n])
            n = n - rodSizes[n]
        }
    }
}
