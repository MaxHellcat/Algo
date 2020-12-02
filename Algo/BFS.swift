//
//  BFS.swift
//  Algo
//
//  Created by Max Reshetey on 02.12.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// An auxiliary color structure used by BFS/DFS algorithms
//
enum VertexColor: CustomStringConvertible { // Not part of a vertex
    case white, gray, black
    public var description: String {
        switch self {
        case .white:
            return "white"
        case .gray:
            return "gray"
        case .black:
            return "black"
        }
    }
}

//
// Time O(V + E)
//
func BFS<T: Hashable>(_ g: Graph<T>, _ s: T) -> [T: T?] {

    // Hint: Use custom Vertex instead of collections below
    var colors = [T: VertexColor]()
    var distances = [T: Int]()
    var parents = [T: T?]()

    g.adj.forEach {
        colors[$0.key] = .white
        distances[$0.key] = Int.max
        parents[$0.key] = nil
    }

    colors[s] = .gray
    distances[s] = 0
    parents[s] = nil

    var queue = [T]()
    queue.append(s)

    while !queue.isEmpty {

        let u = queue.first!
        queue.removeFirst() // Dequeue

        for (v,_) in g.adj[u]! {
            if colors[v] == .white {
                distances[v] = distances[u]! + 1
                parents[v] = u
                colors[v] = .gray
                queue.append(v) // Enqueue
            }
        }

        colors[u] = .black
    }

    print("Colors: \(colors)")
    print("Distances: \(distances)")
    print("Parents: \(parents)")

    return parents
}

//
// Time O(path length)
//
func PrintPath<T: Hashable>(_ g: Graph<T>, _ s: T, _ v: T, _ parents: [T: T?]) {

    guard g.adj[s] != nil && g.adj[v] != nil else {
        assertionFailure("Attempt to print path for missing vertices")
        return
    }

    if v == s {
        print(s)
    }
    else if parents[v] == nil {
        print("No path from \(s) to \(v) exists")
    }
    else {
        PrintPath(g, s, (parents[v]!)!, parents)
        print(v)
    }
}

enum BFSTests {

    static func testAll() {

        print("Test BFS")

        // TODO: Where's this graph from?
        let g = Graph<Int>(type: .directed)
        g.addVertices([1, 3, 5, 7, 9])
        g.addEdge(3, 1)
        g.addEdge(3, 5)
        g.addEdge(3, 7)
        g.addEdge(3, 9)
        g.addEdge(1, 7)

        print("Graph:\n\(g)")

        let parents = BFS(g, 3)

        print("Shortest path between vertices:")
        PrintPath(g, 3, 7, parents)
    }
}
