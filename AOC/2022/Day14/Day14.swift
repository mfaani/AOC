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
        var reader = Reader(fileName: "day14-sample")
        lazy var input = reader.read()
        var grid: [Point: Material] = [:]
        
        mutating func solveA() {
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                placeRocks(from: line.components(separatedBy: " -> ").map(createPoint(from:)))
            }
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
    }
}

