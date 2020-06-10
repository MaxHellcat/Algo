//
//  ActivitySelection.swift
//  Algo
//
//  Created by Max Reshetey on 09.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

///
/// Time exponential?
///
/// Exercise 16.1-1 in CLRS
///
func activitySelectorDynamicTopDown(_ s: Array<Int>, _ f: Array<Int>) -> (val: Int, i: Int, j: Int) {

    var mem = Dictionary<String, (Int,Int,Int)>()

    let val = activitySelectorDynamicTopDownAux(s, f, 0, s.count-1, &mem)

    return val
}

func activitySelectorDynamicTopDownAux(_ s: Array<Int>, _ f: Array<Int>, _ i: Int, _ j: Int, _ mem: inout Dictionary<String, (Int,Int,Int)>) -> (val: Int, i: Int, j: Int) {

    assert(s.count == f.count)
    guard !s.isEmpty else { return (0, 0, 0) }

    if i == j {
        return (1, i, j)
    }

    if i > j {
        return (0, 0, 0)
    }

    if let val = mem["\(i),\(j)"] {
        return val
    }

    var maxVal = 0, maxI = 0, maxJ = 0

    for k in i...j {

        let left = activitySelectorDynamicTopDownAux(s, f, i, k-1, &mem)
        let right = activitySelectorDynamicTopDownAux(s, f, k+1, j, &mem)

        var val = 0, valI = 0, valJ = 0

        if k > i && k < j {

            if f[left.j] <= s[right.i] {

                val = left.val + right.val

                if (s[k] >= f[left.j]) && (f[k] <= s[right.i]) {
                    val += 1
                }

                valI = left.i
                valJ = right.j
            }
            else if left.val > right.val {

                val = left.val
                valI = left.i
                valJ = left.j
            }
            else {

                val = right.val
                valI = right.i
                valJ = right.j
            }
        }
        else if k > i { // k == j

            val = left.val
            valI = left.i
            valJ = left.j

            if f[left.j] <= s[k] {
                val += 1
                valJ = k
            }
        }
        else if k < j { // k == i

            val = right.val
            valI = right.i
            valJ = right.j

            if f[k] <= s[right.i] {
                val += 1
                valI = k
            }
        }

        if maxVal < val {
            maxVal = val
            maxI = valI
            maxJ = valJ
        }
    }

    mem["\(maxI),\(maxJ)"] = (maxVal, maxI, maxJ)

    return (maxVal, maxI, maxJ)
}

///
/// Time O(n^2), where n = s.count = f.count
///
/// Exercise 16.1-1 in CLRS
///
func activitySelectorDynamicBottomUp(_ s: Array<Int>, _ f: Array<Int>) -> Int {

    assert(s.count == f.count)
    guard !s.isEmpty else { return 0 }

    var mem = Array<Int>(repeating: 0, count: s.count)

    var maxVal = 0

    for i in 1..<s.count {

        maxVal = 0

        for j in 0..<i {

            var val = mem[j]

            if f[j] <= s[i] {
                val += 1
            }

            maxVal = max(maxVal, val)
        }

        mem[i-1] = maxVal
    }

    return maxVal
}

///
/// Time O(n), where n = s.count = f.count
///
func activitySelectorGreedyRecursive(_ s: Array<Int>, _ f: Array<Int>, _ k: Int, _ n: Int) -> Array<Int> {

    assert(s.count == f.count)

    var m = k + 1

    let prevFk = k >= 0 ? f[k] : 0 // Cos we start with k = -1

    while m <= n && s[m] < prevFk {
        m += 1
    }

    if m <= n {
        return [m] + activitySelectorGreedyRecursive(s, f, m, n)
    }

    return []
}

///
/// Time O(n), where n = s.count = f.count
///
func activitySelectorGreedyIterative(_ s: Array<Int>, _ f: Array<Int>) -> Array<Int> {

    assert(s.count == f.count)
    guard !s.isEmpty else { return [] }

    var k = 0
    var arr = [k]

    for i in k+1 ..< s.count {

        if s[i] >= f[k] {
            arr.append(i)
            k = i
        }
    }

    return arr
}

public enum ActivitySelection {

    public static func test() {

        // [a1, a4, a8, a11], [a2, a4, a9, a11]
        let s = [1, 3, 0, 5, 3, 5, 06, 08, 08, 02, 12]
        let f = [4, 5, 6, 7, 9, 9, 10, 11, 12, 14, 16]
//        let s = [1, 3, 0, 3, 5, 06, 08, 08, 02, 12]
//        let f = [4, 5, 6, 9, 9, 10, 11, 12, 14, 16]
//        let s = [1, 2, 4]
//        let f = [3, 5, 6]
//        let s = [1, 2, 4, 6, 7]
//        let f = [3, 5, 6, 9, 29] // TODO: GreedyIterative fails here
//        let s = [1]
//        let f = [2]
//        let s: Array<Int> = []
//        let f: Array<Int> = []
//        let s = [1, 3, 5, 7, 09, 11, 13, 15, 17, 19, 21, 23, 25, 27, 28]
//        let f = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]

        let val = activitySelectorDynamicTopDown(s, f)
        print("DynamicRecursiv: \(val)")
//        let val1 = activitySelectorDynamicBottomUp(s, f)
//        print("DynamicBottomUp: \(val1)")

        let arr1 = activitySelectorGreedyRecursive(s, f, -1, s.count-1)
        print("GreedyRecursive: \(arr1)")
        let arr2 = activitySelectorGreedyIterative(s, f)
        print("GreedyIterative: \(arr2)")
    }
}
