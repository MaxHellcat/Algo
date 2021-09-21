//
//  RabinKarpMatcher.swift
//  Algo
//
//  Created by Max Reshetey on 23.08.2021.
//  Copyright © 2021 Magic Unicorn Inc. All rights reserved.
//

import Foundation

// Time O(m) preprocessing, O((n-m+1)m) matching, space O(1)
func RabinKarpMatcher(_ T: [Int], _ P: [Int], _ d: Int, _ q: Int) {
    let n = T.count
    let m = P.count
    let h = Int(pow(Double(d),Double(m-1))) % q
    var p = 0
    var t = 0

    for i in 0..<m { // preprocessing
        p = ((d*p + P[i]) % q)
        t = ((d*t + T[i]) % q)
    }

    for s in 0...n-m { // matching
        if p == t {
            print("Hit \(p) at shift \(s)")
            if compare(T, s, P) {
                print("Found `\(p)` in `\(t)` with valid shift \(s)")
            }
            else {
                print("spurious hit!")
            }
        }
        if s < n-m {
            let val = (d*(t-h*T[s]) + T[s+m])
            t = (val % q)
            t = (t >= 0 ? t : t+q) // Tweak % to work correctly with negative val
        }
    }
}

public enum RabinKarpMatcher_Tests: Tests {
    public static func test() {
        // Testing on 0..9 digits, can be easily adjusted for ascii
        let d = 10 // size of alphabet, i.e. |Sigma|
        let q = 13 // prime such that d*q fits within a computer word
        let T = [2,3,5,9,0,2,3,1,4,1,5,2,6,7,3,9,9,2,1]
        let P1 = [3,1,4,1,5] // exists
        print("Search \(P1)")
        RabinKarpMatcher(T, P1, d, q)
        let P2 = [1,4,1,5,3] // missing
        print("Search \(P2)")
        RabinKarpMatcher(T, P2, d, q)
    }
}
