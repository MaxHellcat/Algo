//
//  BellmanFord.swift
//  Algo
//
//  Created by Max Reshetey on 02.12.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time O(VE)
//
func BellmanFord<T: Hashable>(_ g: Graph<T>, s: T) -> Bool {

    // O(V)
    func initSingleSource(_ g: Graph<T>, _ s: T) {
        for v in g.adj.keys {
            d[v] = Int.max
            p[v] = nil
        }
        d[s] = 0
    }

    // O(1)
    func relax(_ u: T, _ v: T, _ w: Int) {
        guard d[u]! != Int.max else { return } // Int.max +/- w causes range exception
        if d[v]! > d[u]! + w {
            d[v] = d[u]! + w
            p[v] = u
        }
    }

    var d = [T: Int]() // shortest-path estimate
    var p = [T: T]()

    initSingleSource(g, s) // O(V)

    for _ in 0..<g.adj.count-1 { // O(V)

        // Note, with current double-loop it's O(E+V), resulting in T = O(V(V+E))!?
        for (u, vs) in g.adj {
            for (v,w) in vs { // For each edge
                relax(u, v, w)
            }
        }
    }

    for (u, vs) in g.adj {
        for (v,w) in vs { // For each edge
            if d[v]! > d[u]! + w {
                return false
            }
        }
    }

    // Not part of algorithm, just for logging
    let to = Character("z") as! T
    print("Shortest path \(s) -> \(to):")
    PrintPath(g, s, to, p)

//    print("See d: \(d)")

    return true
}

enum BellmanFordTests {

    static func testAll() {

        testWithoutNegativeLoopsAndReturnTrue()
        testWithNegativeLoopsAndReturnFalse()
    }

    static func testWithoutNegativeLoopsAndReturnTrue() {

        print("Test BellmanFord returns true")

        // Figure 24.4 CLRS
        let g = Graph<Character>(type: .directed)
        g.addVertices(["s", "t", "x", "y", "z"])
        g.addEdge("s", "t", 6)
        g.addEdge("s", "y", 7)
        g.addEdge("t", "x", 5)
        g.addEdge("t", "y", 8)
        g.addEdge("t", "z", -4)
        g.addEdge("x", "t", -2)
        g.addEdge("z", "s", 2)
        g.addEdge("z", "x", 7)
        g.addEdge("y", "x", -3)
        g.addEdge("y", "z", 9)
        print("Graph:\n\(g)")

        let result = BellmanFord(g, s: "s")
        print("BellmanFord -> \(result)")

        assert(result == true, "Test FAILED")
    }

    static func testWithNegativeLoopsAndReturnFalse() {

        print("Test BellmanFord returns false")

        // Figure 24.4 CLRS with w(z,x) = 4
        let g = Graph<Character>(type: .directed)
        g.addVertices(["s", "t", "x", "y", "z"])
        g.addEdge("s", "t", 6)
        g.addEdge("s", "y", 7)
        g.addEdge("t", "x", 5)
        g.addEdge("t", "y", 8)
        g.addEdge("t", "z", -4)
        g.addEdge("x", "t", -2)
        g.addEdge("z", "s", 2)
        g.addEdge("z", "x", 4) // Was 7
        g.addEdge("y", "x", -3)
        g.addEdge("y", "z", 9)
        print("Graph:\n\(g)")

        let result = BellmanFord(g, s: "s")
        print("BellmanFord -> \(result)")

        assert(result == false, "Test FAILED")
    }
}
