//
//  Graph.swift
//  Algo
//
//  Created by Max Reshetey on 29.06.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

public class Graph {

    class Vertex {
        enum Color {
            case white, gray, black
        }
        let tag: Int
        var color: Color = .white
        var distance: Int = 0
        var parent: Int? = nil
        init(tag: Int) {
            self.tag = tag
        }
    }

    private var adj: Array<(Vertex,Array<Int>)>

    init(vertices: Array<Int>, edges: Array<(Int,Int)>) {

        adj = vertices.map{(Vertex(tag: $0),[])}

        for (u,v) in edges {
            assert(u-1 >= 0 && u-1 < adj.count)
            assert(v-1 >= 0 && v-1 < adj.count)
            adj[u-1].1.append(v)
        }
    }

    //
    // Time O(E+V)
    //
    func breadthFirstSearch(_ sTag: Int) {

        let s = adj[sTag-1].0
        s.color = .gray
        s.distance = 0
        s.parent = nil

        var queue = Array<Int>()
        queue.append(sTag)

        while !queue.isEmpty {

            let uTag = queue.first!
            queue.remove(at: 0)

            let u = adj[uTag-1].0

            for vTag in adj[uTag-1].1 {
                let v = adj[vTag-1].0
                if v.color == .white {
                    v.distance = u.distance + 1
                    v.parent = u.tag
                    v.color = .gray
                    queue.append(v.tag)
                }
            }

            u.color = .black
        }
    }

    //
    // Time O(path length)
    //
    func printPath(_ sTag: Int, _ vTag: Int) {

        let v = adj[vTag-1].0

        if vTag == sTag {
            print(sTag)
        }
        else if v.parent == nil {
            print("No path from \(sTag) to \(vTag) exists")
        }
        else {
            printPath(sTag, v.parent!)
            print(vTag)
        }
    }
}

extension Graph: CustomStringConvertible {

    public var description: String {
        var s = ""
        for (u, vs) in adj {
            s += "\(u):\(vs)\n"
        }
        return s
    }
}

extension Graph.Vertex: CustomStringConvertible {

    var description: String {
        return "\(tag), \(color), d: \(distance), p: \(String(describing: parent))"
    }
}

extension Graph {

    public static func test() {

        let graph = Graph(vertices: [1, 2, 3, 4, 5], edges: [(1,2), (1,4), (2,3), (2,5)])

        print("See graph:")
        print(graph)

        graph.breadthFirstSearch(1)

        print("See graph:")
        print(graph)

        print("See BFS tree:")
        graph.printPath(2, 4)
    }
}
