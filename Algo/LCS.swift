//
//  LCS.swift
//  Algo
//
//  Created by Max Reshetey on 01.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

///
/// Time O(2^n), where n = min(X, Y)
///
func lcsRecursive(_ X: Array<Character>, _ Y: Array<Character>, _ i: Int, _ j: Int) -> Int {

    if i == -1 || j == -1 {
        return 0
    }

    if X[i] == Y[j] {
        return lcsRecursive(X, Y, i-1, j-1) + 1
    }

    let lcs1 = lcsRecursive(X, Y, i-1, j)
    let lcs2 = lcsRecursive(X, Y, i, j-1)

    return max(lcs1, lcs2)
}

///
/// Time O(mn), where m = X.count, n = Y.count
///
/// Exercise 15.4-3 in CLRS
///
func lcsTopDown(_ X: Array<Character>, _ Y: Array<Character>) -> Int {

    var mem = Array<Array<Int>>(repeating: Array<Int>(repeating: -1, count: Y.count), count: X.count)

    return lcsTopDownAux(X, Y, X.count-1, Y.count-1, &mem)
}

func lcsTopDownAux(_ X: Array<Character>, _ Y: Array<Character>, _ i: Int, _ j: Int, _ mem: inout Array<Array<Int>>) -> Int {

    if i == -1 || j == -1 {
        return 0
    }

    if mem[i][j] > -1 {
        return mem[i][j]
    }

    if X[i] == Y[j] {
        return lcsTopDownAux(X, Y, i-1, j-1, &mem) + 1
    }

    let lcs1 = lcsTopDownAux(X, Y, i-1, j, &mem)
    let lcs2 = lcsTopDownAux(X, Y, i, j-1, &mem)

    let val = max(lcs1, lcs2)

    mem[i][j] = val

    return val
}

///
/// Time O(mn), where m = X.count, n = Y.count
///
func lcsBottomUp(_ X: Array<Character>, _ Y: Array<Character>) -> (Array<Array<Int>>, Array<Array<Character>>) {

    var mem = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: Y.count+1), count: X.count+1)
    var b = Array<Array<Character>>(repeating: Array<Character>(repeating: ".", count: Y.count), count: X.count)

    for i in 1..<X.count+1 {
        for j in 1..<Y.count+1 {

            if X[i-1] == Y[j-1] {
                mem[i][j] = mem[i-1][j-1] + 1
                b[i-1][j-1] = "↖︎"
            }
            else if mem[i-1][j] >= mem[i][j-1] {
                mem[i][j] = mem[i-1][j]
                b[i-1][j-1] = "↑"
            }
            else {
                mem[i][j] = mem[i][j-1]
                b[i-1][j-1] = "←"
            }
        }
    }

    return (mem, b)
}

func printLCS(_ b: Array<Array<Character>>, _ X: Array<Character>, _ i: Int, _ j: Int) {

    if (i == -1 || j == -1) {
        return
    }

    if b[i][j] == "↖︎" {
        printLCS(b, X, i-1, j-1)
        print(X[i])
    }
    else if b[i][j] == "←" {
        printLCS(b, X, i, j-1)
    }
    else if b[i][j] == "↑" {
        printLCS(b, X, i-1, j)
    }
}

func printTable(_ X: [Character], _ Y: [Character], _ b: Array<Array<Character>>) {

    print("  \(Y)")
    for i in 0..<b.count {
        print("\(X[i]) \(b[i])")
    }
}

public enum LCS {

    public static func test() {

        let X: [Character] = ["A", "B", "C", "B", "D", "A", "B"]
        let Y: [Character] = ["B", "D", "C", "A", "B", "A"]
//        let X: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
//        let Y: [Character] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "a"]
//        let X: [Character] = ["a", "b", "c", "d"]
//        let Y: [Character] = ["1", "2", "3", "4"]
//        let X: [Character] = ["1", "0", "0", "1", "0", "1", "0", "1"]
//        let Y: [Character] = ["0", "1", "0", "1", "1", "0", "1", "1", "0"]

        let val1 = lcsRecursive(X, Y, X.count-1, Y.count-1)
        print("Val1: \(val1)")

        let val2 = lcsTopDown(X, Y)
        print("Val2: \(val2)")

        let (c, b) = lcsBottomUp(X, Y)
        print("Val3: \(c[X.count][Y.count])")
        printLCS(b, X, X.count-1, Y.count-1)
        printTable(X, Y, b)
    }
}
