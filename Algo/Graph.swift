//
//  Graph.swift
//  Algo
//
//  Created by Max Reshetey on 29.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

public class Graph {

    enum VertexColor {
        case white, gray, black
    }

    private var adj: Array<(Int,Array<Int>)>

    var colors: Array<VertexColor>
    var distances: Array<Int>
    var parents: Array<Int?>

    init(vertices: Array<Int>, edges: Array<(Int,Int)>) {

        colors = Array<VertexColor>(repeating: .white, count: vertices.count)
        distances = Array<Int>(repeating: 0, count: vertices.count)
        parents = Array<Int?>(repeating: nil, count: vertices.count)

        adj = vertices.map{($0,[])}

        for (u,v) in edges {
            assert(u >= 0 && u < adj.count)
            assert(v >= 0 && v < adj.count)
            adj[u].1.append(v)
        }
    }

    //
    // Time O(E+V)
    //
    func breadthFirstSearch(_ s: Int) {

        colors[s] = .gray

        var queue = Array<Int>()
        queue.append(s)

        while !queue.isEmpty {

            let u = queue.first!
            queue.remove(at: 0)

            for v in adj[u].1 {
                if colors[v] == .white {
                    distances[v] = distances[u] + 1
                    parents[v] = u
                    colors[v] = .gray
                    queue.append(v)
                }
            }

            colors[u] = .black
        }
    }

    //
    // Time O(path length)
    //
    func printPath(_ s: Int, _ v: Int) {

        assert(s >= 0 && s < adj.count)
        assert(v >= 0 && v < adj.count)

        if v == s {
            print(s)
        }
        else if parents[v] == nil {
            print("No path from \(s) to \(v) exists")
        }
        else {
            printPath(s, parents[v]!)
            print(v)
        }
    }
}

extension Graph: CustomStringConvertible {

    public var description: String {
        var s = ""
        for (u, vs) in adj {
            s += "\(u), \(colors[u]):\(vs)\n"
        }
        return s
    }
}

extension Graph {

    public static func test() {

        let graph = Graph(vertices: [0, 1, 2, 3, 4], edges: [(0,1), (0,3), (1,2), (1,4)])

        print("See graph:")
        print(graph)

        graph.breadthFirstSearch(0)

        print("See graph:")
        print(graph)

        print("See BFS tree:")
        graph.printPath(1, 3)
    }
}
