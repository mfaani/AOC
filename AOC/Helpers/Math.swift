//
//  Math.swift
//  AOC
//
//  Created by mfaani on 12/15/22.
//

import Foundation

struct Math {
    enum Operation: String {
        case plus = "+"
        case minus = "-"
        case multiply = "*"
        case divide = "/"
    }
}

extension Int {
    func apply(_ operation: Math.Operation, with num: Int) -> Int {
        switch operation {
        case .plus:
             return self + num
        case .minus:
            return self - num
        case .multiply:
            return self * num
        case .divide:
            return self / num
        }
    }
}

typealias Vector = Point
typealias Size = Point
struct Point: Hashable {
    var x: Int
    var y: Int
}

//extension Point {
//    var straightNeighbors: [Point] {
//        return [Point(x: x + 1, y: y), Point(x: x - 1, y: y), Point(x: x, y: y + 1), Point(x: x, y: y - 1)]
//    }
//}
