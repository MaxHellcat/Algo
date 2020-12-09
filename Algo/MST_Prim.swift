//
//  MST_Prim.swift
//  Algo
//
//  Created by Max Reshetey on 09.12.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

class V: Keyable, Hashable, CustomStringConvertible {
    static func == (lhs: V, rhs: V) -> Bool { // Equatable
        return lhs.tag == rhs.tag
    }

    let tag: Character
    var key = 0 // Keyable
    init(tag: Character) {
        self.tag = tag
    }
    func hash(into hasher: inout Hasher) { // Hashable
        hasher.combine(tag)
    }
    var description: String { // CustomStringConvertible
        return tag.description
    }

    weak var heapNodeRef: MinHeap<V>.Node? // Valid means self currently in heap
    weak var p: V?
}

//
// Time: O(V*lgV) as current implementation uses min-heap
//
func MST_Prim(graph g: Graph<V>, r: V) {

    for v in g.adj.keys {
        v.key = Int.max
        v.p = nil
    }
    r.key = 0

    // Custom code to properly build min heap
    var heapNodes: [MinHeap<V>.Node] = []
    for v in g.adj.keys {
        let node = MinHeap.Node(object: v)
        v.heapNodeRef = node
        heapNodes.append(node)
    }
    let Q = MinHeap<V>(nodes: heapNodes)
//    print("Heap: \(Q)")

    while !Q.isEmpty {

        let u = Q.extractMin()
        u.heapNodeRef = nil // Custom code

        for (v,w) in g.adj[u]! {
            if v.heapNodeRef != nil && w < v.key {
                v.p = u
                Q.decrease(node: v.heapNodeRef!, key: w) // Implicit v.key = w
            }
        }
    }

    let sum = g.adj.keys.reduce(0, {$0+$1.key})

    print("MST_Prim min weight: \(sum)")

    assert(sum == 37) // The total weight of the tree shown is 37.
}

enum MST_PrimTests {

    static func testAll() {

        // Figure 23.1 CLRS
        let g = Graph<V>(type: .undirected)
        let a = V(tag: "a")
        let b = V(tag: "b")
        let c = V(tag: "c")
        let d = V(tag: "d")
        let e = V(tag: "e")
        let f = V(tag: "f")
        let gg = V(tag: "g")
        let h = V(tag: "h")
        let i = V(tag: "i")
        g.addVertices([a, b, c, d, e, f, gg, h, i])
        g.addEdge(a, b, 4)
        g.addEdge(a, h, 8)
        g.addEdge(b, c, 8)
        g.addEdge(b, h, 11)
        g.addEdge(c, d, 7)
        g.addEdge(c, f, 4)
        g.addEdge(c, i, 2)
        g.addEdge(d, e, 9)
        g.addEdge(d, f, 14)
        g.addEdge(e, f, 10)
        g.addEdge(f, gg, 2)
        g.addEdge(gg, h, 1)
        g.addEdge(gg, i, 6)
        g.addEdge(h, i, 7)
        print("Graph: \n\(g)")

        MST_Prim(graph: g, r: a)
    }
}
