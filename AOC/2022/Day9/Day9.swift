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
        
        var knottedRope = KnottedRope()
        mutating func solveB() -> Int {
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                let components = line.components(separatedBy: .whitespaces).filterOutEmpties()
                let direction = Direction(rawValue: components[0])!
                let amount = Int(components[1])!
                let motion = Motion(direction: direction, amount: amount)
                print("line: \(motion)")
                knottedRope.moveHead(from: motion)
            }
            return knottedRope.visitedTails.count
        }
    }
}

extension Point {
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
            h.move(with: Motion(direction: direction, amount: 1))
            
            let vector = getVector()
            moveTail(basedOn: vector)
        }
    }
    
    func getVector() -> Vector {
        return Vector(x: h.x - t.x, y: h.y - t.y)
    }
    
    mutating func moveTail(basedOn vector: Vector)  {
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
        visitedTails.insert(t)
    }
}

struct KnottedRope {
    var points: [Point] = Array(repeating: Point(x: 0, y: 0), count: 10)
    
    var visitedTails: Set<Point> = [Point(x: 0, y: 0)]
    
    mutating func moveHead(from motion: Motion) {
        let direction = motion.direction
        for _ in 1...motion.amount {
            points[0].move(with: Motion(direction: direction, amount: 1))
            for i in points[..<(points.count - 1)].indices {
                let vector = getVector(p1: points[i] , p2: points[i + 1])
                points[i + 1] = move(t: points[i + 1], basedOn: vector, h: points[i], isTail: i + 1 == points.count - 1 ? true : false)
            }
        }
    }
    
    func getVector(p1: Point, p2: Point) -> Vector {
        return Vector(x: p1.x - p2.x, y: p1.y - p2.y)
    }
    
    mutating func move(t: Point, basedOn vector: Vector, h: Point, isTail: Bool) -> Point {
        var shouldMove: Bool {
            return vector.x.magnitude > 1 || vector.y.magnitude > 1
        }
        guard shouldMove else { return t}
        let newTail: Point
        if vector.x.magnitude == 2 && vector.y == 0 {
            newTail = Point(x: (h.x + t.x) / 2, y: t.y)
        } else if vector.y.magnitude == 2 && vector.x == 0 {
            newTail = Point(x: t.x, y: (h.y + t.y) / 2)
        } else if vector.x.magnitude + vector.y.magnitude == 3 {
            newTail = Point(x: t.x + vector.diagonalMovement.x, y: t.y + vector.diagonalMovement.y)
        } else {
            newTail = Point(x: (h.x + t.x) / 2, y: (h.y + t.y) / 2)
        }
        // SHOULD ONLY BE THE LAST TAIL
        if isTail {
            let res = visitedTails.insert(newTail)
            
            if res.inserted {
                print("newMember:", res.memberAfterInsert)
            }
        }
        return newTail
    }
}

/* MINE
 FIRST 9
 newMember: Point(x: 1, y: -2)
 newMember: Point(x: 2, y: -3)
 newMember: Point(x: 1, y: -4)
 newMember: Point(x: 2, y: -5)
 newMember: Point(x: 3, y: -6)
 newMember: Point(x: 2, y: -7)
 newMember: Point(x: 1, y: -8)
 newMember: Point(x: 2, y: -9)

 
 
 newMember: Point(x: -212, y: 346)
 newMember: Point(x: -211, y: 345)
 newMember: Point(x: -210, y: 344)
 newMember: Point(x: -210, y: 345)
 newMember: Point(x: -210, y: 346)
 newMember: Point(x: -210, y: 347)
 newMember: Point(x: -211, y: 348)
 newMember: Point(x: -212, y: 349)
 newMember: Point(x: -213, y: 350)
 newMember: Point(x: -214, y: 351)

 */
