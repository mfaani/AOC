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

extension Point {
    /// returns the points between two points.
    /// - ATTENTION: Will crash if the line isn't straight.
    func inBetweenPoints(with p2: Point) -> [Point] {
        if x == p2.x {
            let minY = min(y, p2.y)
            let maxY = max(y, p2.y)
            
            return (minY...maxY).map { Point(x: x, y: $0)}
        } else if y == p2.y {
            let minX = min(x, p2.x)
            let maxX = max(x, p2.x)
            
            return (minX...maxX).map { Point(x: $0, y: y)}
        } else {
            fatalError()
        }
    }
    
    init(str: String) {
        let parts = str.components(separatedBy: ",")
        x = Int(parts[0])!
        y = Int(parts[1])!
    }
}

