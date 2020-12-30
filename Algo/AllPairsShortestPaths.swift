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
func SlowAllPairsShortestPaths(_ w: [[Int]]) -> ([[Int]], [[Int]]) {

    let n = w.count
    var p = createP1(w) // Added to compute predecessor matrix
    var l = w
    for _ in 2...n-1 {
        (l, p) = ExtendShortestPaths(l, w, p)
        PrintGraph(p)
        PrintGraph(l)
    }
    return (l, p)
}

// Added to compute predecessor matrix
fileprivate func createP1(_ w: [[Int]]) -> [[Int]] {

    let n = w.count
    var result = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: n), count: n)
    for i in 0..<n {
        for j in 0..<n {
            if i != j && w[i][j] != INF {
                result[i][j] = i
            }
            else {
                result[i][j] = INF
            }
        }
    }
    return result
}

// Time Ø(n^3*lgn)
func FasterAllPairsShortestPaths(_ w: [[Int]]) -> [[Int]] {

    let n = w.count
    var p = createP1(w) // Not needed here, but added to make ExtendShortestPaths work
    var l = w
    var m = 1
    while m < n-1 {
        (l, p) = ExtendShortestPaths(l, l, p)
        m = 2*m
    }
    return l
}

// Time Ø(n^3)
fileprivate func ExtendShortestPaths(_ l: [[Int]], _ w: [[Int]], _ p: [[Int]]) -> ([[Int]], [[Int]]) {

    let n = l.count
    var lPrime = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: n), count: n)
    var pPrime = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: n), count: n)
    for i in 0..<n {
        for j in 0..<n {
//            lPrime[i][j] = INF // Original
            lPrime[i][j] = l[i][j] // Added to compute predecessor matrix
            pPrime[i][j] = p[i][j] // Added to compute predecessor matrix
            for k in 0..<n {
                // Check for < INF is unrelated to algorithm, as Int.max +/- w causes range exception
                if l[i][k] < INF && w[k][j] < INF && lPrime[i][j] > l[i][k] + w[k][j] {
                    lPrime[i][j] = l[i][k] + w[k][j]
                    pPrime[i][j] = k // Added to compute predecessor matrix
                }
            }
        }
    }

    return (lPrime, pPrime)
}

fileprivate func PrintAllPairsShortestPath(_ p: [[Int]], _ i: Int, _ j: Int) {

    if i == j {
        print(i)
    }
    else if p[i][j] == INF {
        print("No path from \(i) to \(j) exists")
    }
    else {
        PrintAllPairsShortestPath(p, i, p[i][j])
        print(j)
    }
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

        let (ls, ps) = SlowAllPairsShortestPaths(w)
        print("Output graph (slow):")
        PrintGraph(ls)

        let i = 0, j = 2
        print("Shortest path from \(i) to \(j):")
        PrintAllPairsShortestPath(ps, i, j)

        let lf = FasterAllPairsShortestPaths(w)
        print("Output graph (fast):")
        PrintGraph(lf)

        assert(ls == lf)
    }
}
