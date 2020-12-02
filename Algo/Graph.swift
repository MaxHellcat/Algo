//
//  Graph.swift
//  Algo
//
//  Created by Max Reshetey on 29.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

public class Graph<T: Hashable> {

    public enum DirectionType {
        case directed, undirected
    }

    private(set) var adj = [T:[(v: T, w: Int)]]()
    private let type: DirectionType

    init(type: DirectionType) {
        self.type = type
    }

    func addVertex(_ v: T) {

        assert(adj[v] == nil, "Attempt to add existing vertex \(v)")
        adj[v] = []
    }

    func addVertices(_ vs: [T]) {

        vs.forEach{
            assert(adj[$0] == nil, "Attempt to add existing vertex \($0)")
            adj[$0] = []
        }
    }

    func addEdge(_ u: T, _ v: T, _ w: Int = 0) {

        assert(adj[u] != nil, "Attempt to add edge for missing vertex")
        assert(!adj[u]!.contains(where: {$0.v == v}), "Attempt to add same edge")
        adj[u]!.append((v: v, w: w))

        if type == .undirected {
            assert(adj[v] != nil, "Attempt to add edge for missing vertex")
            assert(!adj[v]!.contains(where: {$0.v == u}), "Attempt to add same edge")
            adj[v]!.append((v: u, w: w))
        }
    }

    //
    // Time Ø(V + E)
    //
    public func topologicalSort() -> [T] {

        var list = [T]()

        // RESTORE
        DFS(self, topologicalList: &list)

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
            for (v,_) in adj[u]! { // explore edge (u, v)
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
        for (v,_) in vs { // For each edge
            if set.findSet(x: u) !== set.findSet(x: v) {
                set.union(x: u, y: v)
            }
        }
    }

    print("Result set: \(set)")
}

// In Kruskal’s algorithm, the set A is a forest whose vertices are
// all those of the given graph. The safe edge added to A is always a least-weight
// edge in the graph that connects two distinct components.
// Time O(E*lgV) (canonical, assuming sorting O(E*lgE) and union O(alpha(V)) amortized)
func MinimumSpanningTree_Kruskal<T: Hashable>(graph g: Graph<T>) -> [(u: T, v: T, w: Int)] {

    let set = DisjointSet<T>()
    for v in g.adj.keys {
        set.makeSet(x: v)
    }
//    print("Initial set: \(set)")

    var edges = [(u: T, v: T, w: Int)]()
    for (u, vs) in g.adj {
        for (v,w) in vs { // For each edge
            edges.append((u: u, v: v, w: w))
        }
    }
    edges.sort(by: {$0.w < $1.w})
//    print("Sorted edges: \(edges)")

    var resultEdges = [(u: T, v: T, w: Int)]() // A
    for edge in edges {
        if set.findSet(x: edge.u) !== set.findSet(x: edge.v) {
            set.union(x: edge.u, y: edge.v)
            resultEdges.append(edge)
        }
    }
//    print("Final set: \(set)")

    return resultEdges
}

// TODO: Created for Prim's algorithm
class V: Keyable, Hashable, CustomStringConvertible {
    static func == (lhs: V, rhs: V) -> Bool {
        return lhs.tag == rhs.tag
    }

    let tag: Character
    var key = 0
    init(tag: Character) {
        self.tag = tag
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(tag)
    }
    var description: String {
        return tag.description
    }
}

// In Prim’s algorithm, the
// set A forms a single tree. The safe edge added to A is always a least-weight edge
// connecting the tree to a vertex not in the tree.
// Time: O(V*lgV) as current implementation uses min-heap
func MinimumSpanningTree_Prim(graph g: Graph<V>, r: V) {

    var parents = [V: V?]()
    var weights = [V: Int]() // MY

    var inQueues = [V: Bool]()
    for v in g.adj.keys {
        v.key = Int.max
        inQueues[v] = true
    }
    r.key = 0
//    print("InQueues: \(inQueues)")

    let heap = BinaryHeap(type: .min, nodes: Array(g.adj.keys))
    print("Heap: \(heap)")

    while heap.count > 0 {

        let u = heap.extractMin() as! V
        inQueues[u] = false

        for (v,w) in g.adj[u]! {

            if inQueues[v] == true && w < v.key {
                parents[v] = u
                weights[v] = w // MY
                heap.decrease(node: v, key: w)
            }
        }
    }

    let sum = weights.values.reduce(0,{$0+$1})

    print("MST_Prim parents: \(parents), count: \(parents.count), weight: \(sum)")

    assert(weights.count == g.adj.count-1) // |G.V|-1
    assert(sum == 37) // The total weight of the tree shown is 37.
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

//        BFSTests.testAll()
//        DFSTests.testAll()
//        testTopologicalSort()
//        testSimplePathCount()
//        testConnectedComponents()
//        testMinimumSpanningTree_Kruskal()
//        testMinimumSpanningTree_Prim()
        BellmanFordTests.testAll()
    }

    static func testMinimumSpanningTree_Prim() {

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

        MinimumSpanningTree_Prim(graph: g, r: a)
    }

    static func testMinimumSpanningTree_Kruskal() {

        // Figure 23.1 CLRS
        let g = Graph<Character>(type: .undirected)
        g.addVertices(["a", "b", "c", "d", "e", "f", "g", "h", "i"])
        g.addEdge("a", "b", 4)
        g.addEdge("a", "h", 8)
        g.addEdge("b", "c", 8)
        g.addEdge("b", "h", 11)
        g.addEdge("c", "d", 7)
        g.addEdge("c", "f", 4)
        g.addEdge("c", "i", 2)
        g.addEdge("d", "e", 9)
        g.addEdge("d", "f", 14)
        g.addEdge("e", "f", 10)
        g.addEdge("f", "g", 2)
        g.addEdge("g", "h", 1)
        g.addEdge("g", "i", 6)
        g.addEdge("h", "i", 7)
        print("Graph: \n\(g)")

        let edges = MinimumSpanningTree_Kruskal(graph: g)
        let sum = edges.reduce(0){$0 + $1.w}

        print("MST_Kruskal edges: \(edges), count: \(edges.count), sum: \(sum)")

        assert(edges.count == g.adj.count-1) // |G.V|-1
        assert(sum == 37) // The total weight of the tree shown is 37.
    }

    static func testConnectedComponents() {

        // Figure 21.1 CLRS
        let g = Graph<Character>(type: .undirected)
        g.addVertex("a")
        g.addVertex("b")
        g.addVertex("c")
        g.addVertex("d")
        g.addEdge("a", "b")
        g.addEdge("a", "c")
        g.addEdge("b", "c")
        g.addEdge("b", "d")

        g.addVertex("e")
        g.addVertex("f")
        g.addVertex("g")
        g.addEdge("e", "f")
        g.addEdge("e", "g")

        g.addVertex("h")
        g.addVertex("i")
        g.addEdge("h", "i")

        g.addVertex("j")

        print("Graph:\n\(g)")

        ConnectedComponents(graph: g)
    }

    static func testSimplePathCount() {

        let g = Graph<Character>(type: .directed)
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

        print("Test Topological Sort")

        let g = Graph<String>(type: .directed)
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
}
