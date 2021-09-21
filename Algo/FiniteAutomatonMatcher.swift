//
//  FiniteAutomatonMatcher.swift
//  Algo
//
//  Created by Max Reshetey on 21.09.2021.
//  Copyright © 2021 Magic Unicorn Inc. All rights reserved.
//

import Foundation

typealias DeltaFunction = [[Character:Int]]

// Time O(n)
func FiniteAutomatonMatcher(_ t: [Character], _ delta: DeltaFunction, _ m: Int) {
    let n = t.count
    var q = 0
    for i in 0..<n {
        q = getNextState(delta, q, t[i])
        if q == m {
            print("Pattern occurs with shift \(i+1-m)")
        }
    }
}

// Time O(|alphabet|*m^3)
fileprivate func computeTransitionFunction(_ p: [Character], _ alphabet: [Character]) -> DeltaFunction {
    var delta = DeltaFunction()
    let m = p.count
    for q in 0...m { // O(m)
        var map = [Character:Int]()
        for c in alphabet { // O(|alphabet|)
            var k = min(m+1, q+2)
            var Pk = [Character]()
            let Pq = (q == 0 ? [] : [Character](p[0..<q])) + [c]
            repeat { // O(m)
                k = k-1
                Pk = [Character](p[0..<k])
            }
            while !isSuffix(Pk, of: Pq) // O(m)
            map[c] = k
        }
        delta.append(map)
    }
    return delta
}

// Time O(|sfx|)
fileprivate func isSuffix(_ sfx: [Character], of s: [Character]) -> Bool {
    guard sfx.count <= s.count else { return false }

    var i = sfx.count-1, j = s.count-1
    while i >= 0 {
        if sfx[i] != s[j] {
            return false
        }
        i -= 1
        j -= 1
    }
    return true
}

fileprivate func getNextState(_ delta: DeltaFunction, _ state: Int, _ c: Character) -> Int {
    assert(state >= 0 && state < delta.count)
    assert(delta[state][c] != nil)
    return delta[state][c]!
}

public enum FiniteAutomatonMatcher_Tests: Tests {
    public static func test() {
//        let a = "abc"
//        let p =   "ababaca"
//        let t = "abababacaba"

        // Test Ex. 32.3-1
//        let a = "ab"
//        let p =   "aabab"
//        let t = "aaababaabaababaab"

        let a = "abcdefghijklmnopqrstuvwxyz !"
        let p = "hello"
        let t = "oh hello there good people!"

        let f = computeTransitionFunction([Character](p), [Character](a))
        FiniteAutomatonMatcher([Character](t), f, p.count)
    }
}
