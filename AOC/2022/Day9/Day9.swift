//
//  Day9.swift
//  AOC
//
//  Created by mfaani on 12/9/22.
//

import Foundation

extension Y2022 {
    struct Day9 {
        let reader = Reader(fileName: "day9")
        lazy var input = reader.read()
        var rope = Rope()
        
        mutating func solveA() -> Int {
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                let components = line.components(separatedBy: .whitespaces).filterOutEmpties()
                let direction = Direction(rawValue: components[0])!
                let amount = Int(components[1])!
                let motion = Motion(direction: direction, amount: amount)
                print("line: \(motion)")
                rope.moveHead(from: motion)
            }
            return rope.visitedTails.count
        }
    }
}
typealias Vector = Point
struct Point: Hashable {
    var x: Int
    var y: Int
    
    mutating func move(with motion: Motion) {
        switch motion.direction {
        case .U:
            y += motion.amount
        case .D:
            y -= motion.amount
        case .R:
            x += motion.amount
        case .L:
            x -= motion.amount
        }
    }
}
extension Vector {
    /// Given that the max distance between H, T is (2,1) or (1,2) along with negative variations e.g. (-2,1) and so on...
    /// The diagonal movement will always be something with (1,1) but respecting the signage of the vector between them.
    /// This variable just returns the correct (1,1) signage as needed.
    var diagonalMovement: Vector {
        var _x: Int = x
        var _y: Int = y
        if x.magnitude > 1 {
            _x = x.signum() * 1
        } else {
            _y = y.signum() * 1
        }
        return Vector(x: _x, y: _y)
    }
}

enum Direction: String {
    case U
    case R
    case D
    case L
}

struct Motion {
    let direction: Direction
    let amount: Int
}

typealias Tail = Point
struct Rope {
    var h: Point = Point(x: 0, y: 0)
    var t: Point = Point(x: 0, y: 0)
    
    var visitedTails: Set<Point> = [Point(x: 0, y: 0)]
    
    mutating func moveHead(from motion: Motion) {
        let direction = motion.direction
        for _ in 0..<motion.amount {
            let prevH = h
            h.move(with: Motion(direction: direction, amount: 1))
//            print("head moved \(direction.rawValue) from:", prevH, "to:", h)
            
            let vector = getVector()
//            print("vector between", h, "and:", t, "is:", vector)
            moveTail(basedOn: vector)
        }
    }
    
    func getVector() -> Vector {
        return Vector(x: h.x - t.x, y: h.y - t.y)
    }
    
    mutating func moveTail(basedOn vector: Vector)  {
        defer {
//            print("head is: \(h) | tail is: \(t) \n")
        }
        var shouldMove: Bool {
            return vector.x.magnitude > 1 || vector.y.magnitude > 1
        }
        guard shouldMove else { return }
        if vector.x.magnitude == 2 && vector.y == 0 {
            t = Point(x: (h.x + t.x) / 2, y: t.y)
        } else if vector.y.magnitude == 2 && vector.x == 0 {
            t = Point(x: t.x, y: (h.y + t.y) / 2)
        } else {
            t = Point(x: t.x + vector.diagonalMovement.x, y: t.y + vector.diagonalMovement.y)
        }
        print(t, "isInserted:", visitedTails.insert(t).inserted)
        
        print(visitedTails.count)
    }
}


