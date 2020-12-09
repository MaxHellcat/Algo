//
//  Dijkstra.swift
//  Algo
//
//  Created by Max Reshetey on 09.12.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

// TODO: Merge with PrintPath
// Modified PrintPath to work with V and return path array
//
// Time O(path length)
//
func Path(_ g: Graph<V>, _ s: V, _ v: V) -> [V] {

    guard g.adj[s] != nil && g.adj[v] != nil else {
        assertionFailure("Attempt to print path for missing vertices")
        return []
    }

    if v == s {
        return [s]
    }
    else if v.p == nil {
        print("No path from \(s) to \(v) exists")
        return []
    }
    else {
        return Path(g, s, v.p!) + [v]
    }
}

func Dijkstra(graph g: Graph<V>, s: V) {

    // TODO: Merge with BellmanFord.initSingleSource
    // O(V)
    func initSingleSource(_ g: Graph<V>, _ s: V) {
        for v in g.adj.keys {
            v.key = Int.max
            v.p = nil
        }
        s.key = 0
    }

    // TODO: Merge with BellmanFord.relax
    // O(1)
    func relax(_ u: V, _ v: V, _ w: Int) {
        guard u.key != Int.max else { return } // Int.max +/- w causes range exception
        if v.key > u.key + w {
            Q.decrease(node: v.heapNodeRef!, key: w) // Implicit v.key = u.key + w
            v.p = u
        }
    }

    initSingleSource(g, s)
    var S: [V] = []

    // Custom code to properly build min heap
    var heapNodes: [MinHeap<V>.Node] = []
    for v in g.adj.keys {
        let node = MinHeap.Node(object: v)
        v.heapNodeRef = node
        heapNodes.append(node)
    }
    let Q = MinHeap<V>(nodes: heapNodes)
//    print("MinHeap: \(Q)")

    while !Q.isEmpty {
        let u = Q.extractMin()
        S.append(u)
        for (v,w) in g.adj[u]! {
            relax(u, v, w)
        }
    }

    assert(S.count == g.adj.keys.count)
}

enum DijkstraTests {

    static func testAll() {

        print("Test Dijkstra's single-source shortest-paths algorithm")

        // Figure 24.6 CLRS
        let g = Graph<V>(type: .directed)
        let s = V(tag: "s")
        let t = V(tag: "t")
        let x = V(tag: "x")
        let y = V(tag: "y")
        let z = V(tag: "z")
        g.addVertices([s, t, x, y, z])
        g.addEdge(s, t, 10)
        g.addEdge(s, y, 5)
        g.addEdge(t, x, 1)
        g.addEdge(t, y, 2)
        g.addEdge(x, z, 4)
        g.addEdge(y, t, 3)
        g.addEdge(y, x, 9)
        g.addEdge(y, z, 2)
        g.addEdge(z, x, 6)
        g.addEdge(z, s, 7)
        print("Graph: \n\(g)")

        Dijkstra(graph: g, s: s)

        let sx = Path(g, s, x)
        print("Shortest path \(s) -> \(x):")
        print(sx)
        let sxWeight = sx.reduce(0,{$0+$1.key})
        print("weight: \(sxWeight)")
        assert(sx.count == 4)
        assert(sxWeight == 9)

        let sz = Path(g, s, z)
        print("Shortest path \(s) -> \(z):")
        print(sz)
        let szWeight = sz.reduce(0,{$0+$1.key})
        print("weight: \(szWeight)")
        assert(sz.count == 3)
        assert(szWeight == 7)

        let ss = Path(g, s, s)
        print("Shortest path \(s) -> \(s):")
        print(ss)
        let ssWeight = ss.reduce(0,{$0+$1.key})
        print("weight: \(ssWeight)")
        assert(ss.count == 1)
        assert(ssWeight == 0)
    }
}
