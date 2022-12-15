//
//  Matt.swift
//  AOC
//
//  Created by Faani Tabrizi Nezhaad, Mohammad on 12/10/22.
//

import Foundation

import Foundation

enum Dir: String {
    case right = "R"
    case left = "L"
    case up = "U"
    case down = "D"
}

struct Coordinates: Hashable {
    var x: Int = 0
    var y: Int = 0
}

class Knot {
    var coordinates = Coordinates()
    var prev: Knot? = nil
    
    func move(_ direction: Dir) {
        switch direction {
        case .right: coordinates.x += 1
        case .left:  coordinates.x -= 1
        case .up:    coordinates.y += 1
        case .down:  coordinates.y -= 1
        }
    }
    
    var tail: Knot {
        var knot = self
        while knot.prev != nil {
            if let prev = knot.prev {
                knot = prev
            }
        }
        return knot
    }
}

struct Move {
    let direction: Dir
    let amount: Int
    
    init?(_ move: [String]) {
        guard let direction = Dir(rawValue: move[0]), let amount = Int(move[1]) else { return nil }
        self.direction = direction
        self.amount = amount
    }
}


struct RopeSimulator {
    let head: Knot
    var tailLocations: Set<Coordinates> = [Coordinates()]
    
    mutating func processMoves(_ moves: [Move]) {
        // move head
        for move in moves {
            for _ in 1...move.amount {
                // move head
                head.move(move.direction)
                
                // move remaining knot(s)
                var current = head.prev
                var next = head
                while let knot = current {
                    moveKnotIfNeeded(knot, next)
                    next = knot
                    current = next.prev
                }
                
                // store tail location if it is new
                let res = tailLocations.insert(head.tail.coordinates)
                if res.inserted {
                    print("newMember:", res.memberAfterInsert)
                }
            }
        }
    }
    
    private func moveKnotIfNeeded(_ knot: Knot, _ next: Knot) {
        let xChange = next.coordinates.x - knot.coordinates.x
        let yChange = next.coordinates.y - knot.coordinates.y
        let moveX = abs(xChange) > 1 || (abs(xChange) > 0 && abs(yChange) > 1)
        let moveY = abs(yChange) > 1 || (abs(yChange) > 0 && abs(xChange) > 1)
        
        if moveX {
            let direction: Dir = xChange < 0 ? .left : .right
            knot.move(direction)
        }
        if moveY {
            let direction: Dir = yChange < 0 ? .down : .up
            knot.move(direction)
        }
    }
}

//MARK: - Part 1

func part1() -> Int {
    let helper = InputHelper(fileName: "dec09Input")
    let moves = helper.inputAsArraySeparatedBy(.newlines)
        .map { $0.components(separatedBy: .whitespaces) }
        .compactMap(Move.init)
    
    let head = Knot()
    let tail = Knot()
    head.prev = tail
    
    var ropeSimulator = RopeSimulator(head: head)
    ropeSimulator.processMoves(moves)
    
    return ropeSimulator.tailLocations.count
}

//MARK: - Part 2

func part2() -> Int {
    let helper = InputHelper(fileName: "day9")
    let moves = helper.inputAsArraySeparatedBy(.newlines)
        .map { $0.components(separatedBy: .whitespaces) }
        .compactMap(Move.init)
    
    let head = Knot()
    var current = head
    for _ in 1...9 {
        let knot = Knot()
        current.prev = knot
        current = knot
    }
    
    var ropeSimulator = RopeSimulator(head: head)
    ropeSimulator.processMoves(moves)
    
    return ropeSimulator.tailLocations.count
}

public struct InputHelper {
    public let inputAsString: String
    
    public init(fileName: String) {
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let stringContents = try! String(contentsOfFile: filePath)
        self.inputAsString = stringContents
    }
    
    public func inputAsArraySeparatedBy(_ separator: CharacterSet) -> [String] {
        return inputAsString.components(separatedBy: separator).filter { !$0.isEmpty }
    }
    
}

public func transpose(_ input: [[Int]]) -> [[Int]] {
    guard !input.isEmpty else { return input }
    var result = [[Int]]()
    for index in 0..<input.first!.count {
        result.append(input.map{$0[index]})
    }
    return result
    
}

public extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}

/* Matt First 9
 newMember: Coordinates(x: 1, y: -1)
 newMember: Coordinates(x: 2, y: -2)
 newMember: Coordinates(x: 2, y: -3)
 newMember: Coordinates(x: 1, y: -4)
 newMember: Coordinates(x: 2, y: -5)
 newMember: Coordinates(x: 3, y: -6)
 newMember: Coordinates(x: 2, y: -7)
 newMember: Coordinates(x: 1, y: -8)

 
 */

/* Matt LAST 10
 newMember: Coordinates(x: -212, y: 346)
 newMember: Coordinates(x: -211, y: 345)
 newMember: Coordinates(x: -210, y: 344)
 newMember: Coordinates(x: -210, y: 345)
 newMember: Coordinates(x: -210, y: 346)
 newMember: Coordinates(x: -210, y: 347)
 newMember: Coordinates(x: -211, y: 348)
 newMember: Coordinates(x: -212, y: 349)
 newMember: Coordinates(x: -213, y: 350)
 newMember: Coordinates(x: -214, y: 351)
 
 */
