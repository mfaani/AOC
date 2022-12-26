//
//  Day15B.swift
//  AOC
//
//  Created by mfaani on 12/22/22.
//

import Foundation

extension Y2022 {
    class Day15B {
        enum Item {
            case sensor
            case beacon
            case none
        }
        
        let targetRow: Int
        let input: String
        var g: GridG<Int,Item> = GridG()
        
        /// - Attention: requires input alteration.
        /// I just removed all the strings. Turned into an array.
        init(fileName: String = "day15", targetRow: Int = 2000000) {
            let reader = Reader(fileName: fileName)
            self.targetRow = targetRow
            input = reader.read()
        }
        
        var rMax = Int.min
        var rMin = Int.max
        var range = 0...0
        func solve() -> Int {
            let start = Date()
            defer { print("Part 1 complete in \(Date().timeIntervalSince(start).rounded()) seconds") }
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                let items = line.components(separatedBy: ",").map { Int($0)!}
                let sensor = Point(x: items[0], y: items[1])
                let beacon = Point(x: items[2], y: items[3])
                if beacon.y == targetRow {
                    g.set(beacon.x, to: .beacon)
                }
                
                rMin = [rMin, sensor.x - sensor.manahattanDistance(with: beacon) , beacon.x].min()!
                rMax = [rMax, sensor.x + sensor.manahattanDistance(with: beacon), beacon.x].max()!
            }
            /// - WARNING: I initially excluded the min/max themselves. I thought they'd each be either a beacon or sensor. But that's true only for one row. Not all others.
            range = rMin...rMax
            return crossOutNoneBeaconsFromRange()
        }
        
        func crossOutNoneBeaconsFromRange() -> Int {
            for i in range {
                for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                    let items = line.components(separatedBy: ",").map { Int($0)!}
                    let sensor = Point(x: items[0], y: items[1])
                    let beacon = Point(x: items[2], y: items[3])

                    if Point(x: i, y: targetRow).manahattanDistance(with: sensor) <= sensor.manahattanDistance(with: beacon) {
                        g.set(i, to: .none, shouldOverride: false)
                    } else {
                        
                    }
                }
            }
            return g.coordinates.filter { $0.value == .none }.count
        }
    }
}
