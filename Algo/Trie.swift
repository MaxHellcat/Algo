//
//  Trie.swift
//  Algo
//
//  Created by Max Reshetey on 31.03.2021.
//  Copyright © 2021 Magic Unicorn Inc. All rights reserved.
//

import Foundation

class Trie {
    class Node {
        var children = [Character:Node]()
        var isWord = false
    }
    var root = Node()

    /** Inserts a word into the trie. */
    // Time O(|word|)
    func insert(_ word: String) {

        var node = root
        for c in word {
            if node.children[c] == nil {
                node.children[c] = Node()
            }
            node = node.children[c]!
        }
        node.isWord = true
    }

    /** Returns if the word is in the trie. */
    // Time O(|word|)
    func search(_ word: String, _ validWorldOnly: Bool = true) -> Bool {

        var node = root
        for c in word {
            if node.children[c] == nil {
                return false
            }
            node = node.children[c]!
        }
        return validWorldOnly ? node.isWord : true
    }

    /** Returns if there is any word in the trie that starts with the given prefix. */
    // Time O(|prefix|)
    func startsWith(_ prefix: String) -> Bool {

        return search(prefix, false)
    }
}

extension Trie: CustomStringConvertible {
    var description: String {
        return visit(root, "").reduce("") {$0+($0.isEmpty ? "" : ", ") + $1}
    }
    private func visit(_ root: Node, _ prefix: String) -> [String] {
        guard !root.children.isEmpty else { return [prefix] }
        var r = [String]()
        for (char, child) in root.children {
            let words = visit(child, prefix+String(char))
            r += words
        }
        return r
    }
}

public enum TrieTests {
    public static func testAll() {
        let trie = Trie()
        trie.insert("apple")
        trie.insert("applause")
        trie.insert("appliance")
        print("See trie: \(trie)")

        var w = "apple"
        print("Search \(w): \(trie.search(w))")
        w = "applicator"
        print("Search \(w): \(trie.search(w))")

        w = "app"
        print("StartsWith \(w): \(trie.startsWith(w))")
        w = "appp"
        print("StartsWith \(w): \(trie.startsWith(w))")
    }
}
