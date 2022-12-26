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
        init(fileName: String = "day15", targetRow: Int = 4) {
            let reader = Reader(fileName: fileName)
            self.targetRow = targetRow
//            input = reader.read()
            input = "2,3,4,5"
        }
        
        var rMax = Int.min
        var rMin = Int.max
        var range = 0...0
        func solve() -> Int {
            
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                let items = line.components(separatedBy: ",").map { Int($0)!}
                let sensor = Point(x: items[0], y: items[1])
                let beacon = Point(x: items[2], y: items[3])
                if beacon.y == targetRow {
                    g.set(beacon.x, to: .beacon)
                }

                rMin = [rMin, sensor.x, beacon.x].min()!
                rMax = [rMax, sensor.x, beacon.x].max()!
            }
            /// - WARNING: I initially excluded the min/max themselves. I thought they'd each be either a beacon or sensor. But that's true only for one row. Not all others.
            range = rMin...rMax
            return crossOutNoneBeaconsFromRange()
            
//            return g.coordinates.filter { $0.key.y == 2000000 && $0.value == .none}.count
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
            
//            g.set(sensor, to: .sensor)
//            g.set(beacon, to: .beacon)
//            
//            let distance = sensor.manahattanDistance(with: beacon)
//            
//            // Using a set because I'm doing the point itself. And then 4 operations on it as well.
//            var vectors: Set<Vector> = []
//            /// - Note: Should not re-set a beacon or sensor location
//            /// `i = 0` means all movement is vertical.
//            for i in (0...distance) {
//                for j in (0...(distance - i)) {
//                    vectors.insert(Vector(x: i, y: j))
//                    vectors.insert(Vector(x: i * -1, y: j))
//                    vectors.insert(Vector(x: i, y: j * -1))
//                    vectors.insert(Vector(x: i * -1, y: j * (-1)))
//                }
//            }
//            
//            for vector in vectors {
//                let newPoint = Point(x: sensor.x + vector.x, y: sensor.y + vector.y)
//                //                print("newPoint:", newPoint)
//                g.set(newPoint, to: .none, shouldOverride: false)
//            }
            //            print("------")
        }
    }
}
