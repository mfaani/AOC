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
        
        lazy var outOfBoundsRanges: (PartialRangeThrough<Int>, PartialRangeFrom<Int>, Int) = {
            var maxX = Int.min
            var minX = Int.max
            var maxY = Int.min
            
            for (key,value) in grid {
                minX = min(minX, key.x)
                maxX = max(maxX, key.x)
                maxY = max(maxY, key.y)
            }
            let rightRange = (maxX + 1)...
            let leftRange = ...(minX - 1)
                        
            return (leftRange, rightRange, maxY)
        }()
        
        mutating func solveA() -> Int{
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                placeRocks(from: line.components(separatedBy: " -> ").map(Point.init(str:)))
            }
            
            /// I just dumped `400` to each side. Didn't think more was needed. And it wasn't!
            ((outOfBoundsRanges.0.upperBound - 400)...(outOfBoundsRanges.1.lowerBound + 400)).forEach {
                grid[Point(x: $0, y: outOfBoundsRanges.2 + 2)] = .rock
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
        
        var didNotReturnPart1 = true
        mutating func fall(from p: Point) {
            let next = p.nextPossibleDroppingPoint

            //          Part1 terminating condition
            if isOutOfBounds(from: p) && didNotReturnPart1 {
               print("part1:", count)
                didNotReturnPart1 = false
            }
            
            if grid[next[0]] == nil {
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
                
                // part 2 terminating Condition. Only if the last item is just diagonally to the bottom right, then there's no more space...
                if p == Point(x: 501, y: 1) {
                    isWithinBounds = false
                }
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
