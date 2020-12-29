//
//  AllPairsShortestPaths.swift
//  Algo
//
//  Created by Max Reshetey on 29.12.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

fileprivate let INF = Int.max

extension Int: CustomDebugStringConvertible {
    public var debugDescription: String {
        return (self == Int.max ? "INF" : "\(self)")
    }
}

fileprivate func PrintGraph(_ g: [[Int]]) {
    let desc = g.reduce("", {$0 + "\($1)\n"})
    print(desc)
}

// Time Ø(n^4)
func SlowAllPairsShortestPaths(_ w: [[Int]]) -> [[Int]] {

    let n = w.count
    var l = w
    for _ in 2...n-1 {
        l = ExtendShortestPaths(l, w)
    }
    return l
}

// Time Ø(n^3*lgn)
func FasterAllPairsShortestPaths(_ w: [[Int]]) -> [[Int]] {

    let n = w.count
    var l = w
    var m = 1
    while m < n-1 {
        l = ExtendShortestPaths(l, l)
        m = 2*m
    }
    return l
}

// Time Ø(n^3)
fileprivate func ExtendShortestPaths(_ l: [[Int]], _ w: [[Int]]) -> [[Int]] {

    let n = l.count
    var lPrime = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: n), count: n)
    for i in 0..<n {
        for j in 0..<n {
            lPrime[i][j] = Int.max
            for k in 0..<n {
                // Int.max +/- w causes range exception
                if l[i][k] < INF && w[k][j] < INF && lPrime[i][j] > l[i][k] + w[k][j] {
                    lPrime[i][j] = l[i][k] + w[k][j]
                }

            }
        }
    }

    return lPrime
}

enum AllPairsShortestPathsTests {

    static func testAll() {

        testSlowAndFasterAllPairsShortestPaths()
    }

    static func testSlowAndFasterAllPairsShortestPaths() {

        print("Test SlowAllPairsShortestPaths algorithm")

        // Directed weighted graph from Figure 25.1
        var w: [[Int]] = []
        w.append([0,    3,      8,      INF,    -4])
        w.append([INF,  0,      INF,    1,      7])
        w.append([INF,  4,      0,      INF,    INF])
        w.append([2,    INF,    -5,     0,      INF])
        w.append([INF,  INF,    INF,    6,      0])

        print("Input graph:")
        PrintGraph(w)

        let ls = SlowAllPairsShortestPaths(w)
        print("Output graph (slow):")
        PrintGraph(ls)

        let lf = FasterAllPairsShortestPaths(w)
        print("Output graph (fast):")
        PrintGraph(lf)

        assert(ls == lf)
    }
}
