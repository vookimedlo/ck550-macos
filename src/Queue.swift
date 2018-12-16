//
//  Queue.swift
//  ck550-cli
//
//  Created by Michal Duda on 28/11/2018.
//  Copyright © 2018 Michal Duda. All rights reserved.
//

import Foundation

class Queue<T> {
    private var list = [T]()

    func enqueue(_ item: T) -> Void {
        list.append(item)
    }

    func dequeue() -> T? {
        return list.isEmpty == false ? list.removeFirst() : nil
    }

    func count() -> Int {
        return list.count
    }
}
