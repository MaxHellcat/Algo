//
//  NaiveStringMatcher.swift
//  Algo
//
//  Created by Max Reshetey on 23.08.2021.
//  Copyright © 2021 Magic Unicorn Inc. All rights reserved.
//

import Foundation

// Time O((n-m+1)m), space O(1)
func NaiveStringMatcher(_ t: [Character], _ p: [Character]) {
    precondition(p.count <= t.count)
    let n = t.count
    let m = p.count
    for s in 0...n-m {
        if compare(t, s, p) {
            print("Found `\(p)` in `\(t)` with valid shift \(s)")
        }
    }
}

// Time O(m), space O(1)
fileprivate func compare(_ t: [Character], _ s: Int, _ p: [Character]) -> Bool {
    let m = p.count
    for i in 0..<m {
        if p[i] != t[s+i] {
            return false
        }
    }
    return true
}

public enum NaiveStringMatcher_Tests {
    public static func test() {
        let t = "I love apple"
        let p1 = "ove"
        print("Search \(p1)")
        NaiveStringMatcher([Character](t), [Character](p1))
        let p2 = "apples"
        print("Search \(p2)")
        NaiveStringMatcher([Character](t), [Character](p2))
    }
}
