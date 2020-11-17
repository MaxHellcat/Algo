//
//  Graph.swift
//  Algo
//
//  Created by Max Reshetey on 29.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

// TODO: Add notion of undirected graph so reverse edges are automatically added, see testConnectedComponents
public class Graph<T: Hashable> {

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

    private(set) var adj = [T:[T]]()

    func addVertex(_ v: T) {

        guard adj[v] == nil else {
            assertionFailure("Attempt to add existing vertex")
            return
        }

        adj[v] = []
    }

    func addEdge(_ u: T, _ v: T) {

        guard adj[u] != nil && adj[v] != nil else {
            assertionFailure("Attempt to add edge for missing vertices")
            return
        }

        guard !adj[u]!.contains(v) else {
            assertionFailure("Attempt to add same edge")
            return
        }

        adj[u]!.append(v)
    }

    //
    // Time O(V + E)
    //
    func breadthFirstSearch(_ s: T) -> [T: T?] {

        var colors = [T: VertexColor]()
        var distances = [T: Int]()
        var parents = [T: T?]()

        adj.forEach {
            colors[$0.key] = .white
            distances[$0.key] = 0
            parents[$0.key] = nil
        }

        colors[s] = .gray
        distances[s] = 0
        parents[s] = nil

        var queue = [T]()
        queue.append(s)

        while !queue.isEmpty {

            let u = queue.first!
            queue.remove(at: 0) // Dequeue

            for v in adj[u]! {
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
    func printPath(_ s: T, _ v: T, _ parents: [T: T?]) {

        guard adj[s] != nil && adj[v] != nil else {
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
            printPath(s, (parents[v]!)!, parents)
            print(v)
        }
    }

    //
    // Time Ø(V + E)
    //
    // topologicalList - populated with finished vertices as DFS proceeds
    func depthFirstSearch(topologicalList: inout [T]) {

        var colors = [T: VertexColor]()
        var discovers = [T: Int]()
        var finishes = [T: Int]()
        var parents = [T: T?]()

        adj.forEach {
            colors[$0.key] = .white
            parents[$0.key] = nil
        }

        var time = 0

        func dfsVisit(_ u: T) {

            time += 1 // white vertex u has just been discovered
            discovers[u] = time
            colors[u] = .gray

            for v in adj[u]! { // explore edge (u, v)
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

        for (u,_) in adj {
            if colors[u] == .white {
                dfsVisit(u)
            }
        }

        print("Colors: \(colors)")
        print("Discovers: \(discovers)")
        print("Finishes: \(finishes)")
        print("Parents: \(parents)")
    }

    //
    // Time Ø(V + E)
    //
    public func topologicalSort() -> [T] {

        var list = [T]()

        depthFirstSearch(topologicalList: &list)

        return list
    }

    // Exercise 22.4-2 CLRS
    //
    // Give a linear-time algorithm that takes as input a directed acyclic graph G = (V,E) and two vertices s and t, and returns the number of simple paths from s to t in G.
    //
    // Solution: The idea is to use a modified DFS that marks discovered vertices that lead to t, to keep linear running time.
    // Time O(V+E), space O(V)
    public func simplePathCount(_ s: T, _ t: T) -> Int {

        // Strictly speaking there's a 0-path for s == t, but exercise example seems to ignore it.
        guard s != t else {
            return 0
        }

        var discovered = [T: Bool]() // Vertices that have been visited (not necessarily finished)
        var included = [T: Bool]() // Vertices that are in some path to t

        adj.forEach {
            discovered[$0.key] = false
            included[$0.key] = false
        }

        var result = 0

        func visit(_ u: T) {

            discovered[u] = true

            print("Visit \(u)")

            guard u != t else { // Stop once we reach t
                included[u] = true
                result = 1
                return
            }

            print("Iterate: \(adj[u]!)")
            for v in adj[u]! { // explore edge (u, v)
                print("\(v) discovered: \(discovered[v]!), leads: \(included[v]!)")
                if discovered[v] == false {
                    visit(v)
                }
                else // Stop once we reach discovered vertice that leads to t
                if included[v] == true {
                    result += 1
                }

                // If at least one edge uv leads to t, mark u so it also leads
                if included[v] == true {
                    included[u] = true
                }
            }
        }

        visit(s)

        return result
    }
}

public func ConnectedComponents<T: Hashable>(graph g: Graph<T>) {

    let set = DisjointSet<T>()

    for v in g.adj.keys {
        set.makeSet(x: v)
    }
    print("Initial set: \(set)")

    for (u, vs) in g.adj {
        for v in vs { // For each edge
            if set.findSet(x: u) !== set.findSet(x: v) {
                set.union(x: u, y: v)
            }
        }
    }

    print("Result set: \(set)")
}

extension Graph: CustomStringConvertible {

    public var description: String {
        var s = ""
        for (u, vs) in adj {
            s += "\(u): \(vs)\n"
        }
        return s
    }
}

public enum GraphTests {

    public static func testAll() {

//        testBFS()
//        testDFS()
//        testTopologicalSort()
//        testSimplePathCount()
        testConnectedComponents()
    }

    static func testConnectedComponents() {

        // Figure 21.1 CLRS
        let g = Graph<Character>()
        g.addVertex("a")
        g.addVertex("b")
        g.addVertex("c")
        g.addVertex("d")
        g.addEdge("a", "b")
        g.addEdge("b", "a") // backward
        g.addEdge("a", "c")
        g.addEdge("c", "a") // backward
        g.addEdge("b", "c")
        g.addEdge("c", "b") // backward
        g.addEdge("b", "d")
        g.addEdge("d", "b") // backward

        g.addVertex("e")
        g.addVertex("f")
        g.addVertex("g")
        g.addEdge("e", "f")
        g.addEdge("f", "e") // backward
        g.addEdge("e", "g")
        g.addEdge("g", "e") // backward

        g.addVertex("h")
        g.addVertex("i")
        g.addEdge("h", "i")
        g.addEdge("i", "h") // backward

        g.addVertex("j")

        print("Graph:\n\(g)")

        ConnectedComponents(graph: g)
    }

    static func testSimplePathCount() {

        let g = Graph<Character>()
        g.addVertex("p")
        g.addVertex("o")
        g.addVertex("s")
        g.addVertex("r")
        g.addVertex("y")
        g.addVertex("v")

        g.addEdge("p", "o")
        g.addEdge("p", "s") //
        g.addEdge("o", "r")
        g.addEdge("o", "v")
        g.addEdge("o", "s") //
        g.addEdge("r", "y")
        g.addEdge("s", "r")
        g.addEdge("y", "v")

        print("\(g)")

        let val = g.simplePathCount("p", "v")

        print("Count: \(val)")
    }

    static func testTopologicalSort() {

        let g = Graph<String>()
        g.addVertex("undershorts")
        g.addVertex("socks")
        g.addVertex("watch")
        g.addVertex("pants")
        g.addVertex("shoes")
        g.addVertex("belt")
        g.addVertex("shirt")
        g.addVertex("tie")
        g.addVertex("jacket")
        g.addEdge("undershorts", "pants")
        g.addEdge("undershorts", "shoes")
        g.addEdge("socks", "shoes")
        g.addEdge("pants", "belt")
        g.addEdge("pants", "shoes")
        g.addEdge("belt", "jacket")
        g.addEdge("shirt", "belt")
        g.addEdge("shirt", "tie")
        g.addEdge("tie", "jacket")

        print("See graph:")
        print(g)

        let list = g.topologicalSort()

        print("See list:")
        print(list)
    }

    static func testBFS() {

        let g = Graph<Int>()
        g.addVertex(1)
        g.addVertex(3)
        g.addVertex(5)
        g.addVertex(7)
        g.addVertex(9)
        g.addEdge(3, 1)
        g.addEdge(3, 5)
        g.addEdge(3, 7)
        g.addEdge(3, 9)
        g.addEdge(1, 7)

        print("See graph:")
        print(g)

        let parents = g.breadthFirstSearch(3)

        print("See graph:")
        print(g)

        print("See the shortest path between vertices:")
        g.printPath(3, 7, parents)
    }

    static func testDFS() {

        let g = Graph<Character>()
        g.addVertex("u")
        g.addVertex("v")
        g.addVertex("w")
        g.addVertex("x")
        g.addVertex("y")
        g.addVertex("z")
        g.addEdge("u", "v")
        g.addEdge("u", "x")
        g.addEdge("v", "y")
        g.addEdge("w", "y")
        g.addEdge("w", "z")
        g.addEdge("x", "v")
        g.addEdge("y", "x")
        g.addEdge("z", "z")

        print("See graph:")
        print(g)

        var topologicalListThatMustNotBeHere = [Character]()
        g.depthFirstSearch(topologicalList: &topologicalListThatMustNotBeHere)

        print("See graph:")
        print(g)
    }
}
