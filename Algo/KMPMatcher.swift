//
//  KMPMatcher.swift
//  Algo
//
//  Created by Max Reshetey on 27.09.2021.
//  Copyright © 2021 Magic Unicorn Inc. All rights reserved.
//

import Foundation

// Time O(n) matching, O(m) preprocessing; space O(m) for prefix function pi
func KMPMatcher(_ t: [Character], _ p: [Character]) {
    let n = t.count
    let m = p.count
    let pi = ComputePrefixFunction(p)
    var q = 0 // number of characters matched
    for i in 0..<n { // scan the text from left to right
        while q > 0 && p[q] != t[i] {
            q = pi[q-1] // next character does not match
        }
        if p[q] == t[i] {
            q += 1 // next character matches
        }
        if q == m { // is all of P matched?
            print("Pattern occurs with shift \((i+1)-m)")
            q = pi[q-1] // look for the next match
        }
    }
}

// Time O(m), space O(m)
fileprivate func ComputePrefixFunction(_ p: [Character]) -> [Int] {
    let m = p.count
    var pi = [Int](repeating: 0, count: m)
    var k = 0
    for q in 1..<m {
        while k > 0 && p[q] != p[k] { // at most m - 1 iterations
            k = pi[k-1]
        }
        if p[q] == p[k] {
            k += 1
        }
        pi[q] = k
    }
    return pi
}

public enum KMPMatcher_Tests {
    public static func test() {

        let t = "I love apple"
        let p1 = "ove"
        print("Search \(p1)")
        KMPMatcher([Character](t), [Character](p1))
        let p2 = "apples"
        print("Search \(p2)")
        KMPMatcher([Character](t), [Character](p2))

        let t1 = "sgngdjgnsgdfgfkmcknevtegt;egd;g',fotvlovemc;scmvkfnb;dgf;d'v;.otierwujwncc"
        let p3 = "lovem"
        KMPMatcher([Character](t1), [Character](p3))
        let p4 = "lovemall"
        KMPMatcher([Character](t1), [Character](p4))

    }
}
