//
//  DFS.swift
//  Algo
//
//  Created by Max Reshetey on 02.12.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time Ø(V + E)
//
// topologicalList - only for topologicalSort(), populated with finished vertices as DFS proceeds
func DFS<T: Hashable>(_ g: Graph<T>, topologicalList: inout [T]) {

    var colors = [T: VertexColor]()
    var discovers = [T: Int]()
    var finishes = [T: Int]()
    var parents = [T: T?]()

    g.adj.forEach {
        colors[$0.key] = .white
        parents[$0.key] = nil
    }

    var time = 0

    func dfsVisit(_ u: T) {

        time += 1 // white vertex u has just been discovered
        discovers[u] = time
        colors[u] = .gray

        for (v,_) in g.adj[u]! { // explore edge (u, v)
            if colors[v] == .white {
                parents[v] = u
                dfsVisit(v)
            }
        }

        colors[u] = .black // blacken u; it is finished
        time += 1
        finishes[u] = time
        topologicalList.insert(u, at: 0)
    }

    for (u,_) in g.adj {
        if colors[u] == .white {
            dfsVisit(u)
        }
    }

    print("Colors: \(colors)")
    print("Discovers: \(discovers)")
    print("Finishes: \(finishes)")
    print("Parents: \(parents)")
}

enum DFSTests {

    static func testAll() {

        print("Test DFS")

        // Figure 22.4 CLRS
        let g = Graph<Character>(type: .directed)
        g.addVertices(["u", "v", "w", "x", "y", "z"])
        g.addEdge("u", "v")
        g.addEdge("u", "x")
        g.addEdge("v", "y")
        g.addEdge("w", "y")
        g.addEdge("w", "z")
        g.addEdge("x", "v")
        g.addEdge("y", "x")
        g.addEdge("z", "z")

        print("Graph:\n\(g)")

        var topologicalListThatMustNotBeHere = [Character]()
        DFS(g, topologicalList: &topologicalListThatMustNotBeHere)
    }
}
