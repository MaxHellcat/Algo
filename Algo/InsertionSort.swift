//
//  InsertionSort.swift
//  Algo
//
//  Created by Max Reshetey on 06.04.2020.
//  Copyright © 2020 Magic Unicorn Inc. All rights reserved.
//

import Foundation

//
// Time O(n^2), space O(1)
//
func insertionSort(_ arr: inout Array<Int>) {

    for i in 1..<arr.count {

        let key = arr[i]
        var j = i-1

        while j >= 0 && key < arr[j] {

            arr[j+1] = arr[j]
            j = j - 1
        }

        arr[j+1] = key
    }
}
