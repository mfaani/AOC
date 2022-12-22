//
//  Day14.swift
//  AOC
//
//  Created by mfaani on 12/21/22.
//

import Foundation

extension Y2022 {
    enum Material {
        case rock
        case sand
        case air
    }
    struct Day14 {
        var reader = Reader(fileName: "day14")
        lazy var input = reader.read()
        var grid: [Point: Material] = [:]
        var pouringPoint = Point(x: 500, y: 0)
        var isWithinBounds = true
        var count = 0
        
        lazy var outOfBoundsRanges: (PartialRangeThrough<Int>, PartialRangeFrom<Int>) = {
            var maxX = Int.min
            var minX = Int.max
            
            for (key,value) in grid {
                minX = min(minX, key.x)
                maxX = max(maxX, key.x)
            }
            let rightRange = (maxX + 1)...
            let leftRange = ...(minX - 1)
                        
            return (leftRange, rightRange)
        }()
        
        mutating func solveA() -> Int{
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                placeRocks(from: line.components(separatedBy: " -> ").map(createPoint(from:)))
            }
            pourSand()
            return count
        }
        
        mutating func placeRocks(from rockPoints: [Point]) {
            var previous = rockPoints[0]
            
            for rock in rockPoints[1...] {
                for point in rock.inBetweenPoints(with: previous) {
                    grid[point] = .rock
                }
                previous = rock
            }
        }
        
        func createPoint(from str: String) -> Point {
            let parts = str.components(separatedBy: ",")
            return Point(x: Int(parts[0])!, y: Int(parts[1])!)
        }
        
        mutating func pourSand() {
            while isWithinBounds {
                fall(from: pouringPoint)
            }
        }
        
        mutating func fall(from p: Point) {
            let next = p.nextPossibleDroppingPoint
            
            if isOutOfBounds(from: p) {
                isWithinBounds = false
            } else if grid[next[0]] == nil {
                // fall down
                fall(from: next[0])
            } else if grid[next[1]] == nil {
                // fall diagonally to the left
                fall(from: next[1])
            } else if grid[next[2]] == nil {
                // fall diagonally to the right
                fall(from: next[2])
            } else {
                grid[p] = .sand
                count += 1
            }

        }
        
        mutating func isOutOfBounds(from p: Point) -> Bool {
            return outOfBoundsRanges.0.contains(p.x) || outOfBoundsRanges.1.contains(p.x)
        }
    }
}

private extension Point {
    /// dropping point is returns
    /// - Attention: Order matters. The first item has prirority.
    var nextPossibleDroppingPoint: [Point] {
        return [Point(x: x, y: y + 1), Point(x: x - 1, y: y + 1), Point(x: x + 1, y: y + 1)]
    }
}
