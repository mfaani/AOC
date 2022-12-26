//
//  Day15.swift
//  AOC
//
//  Created by mfaani on 12/22/22.
//

import Foundation

extension Y2022 {
    class Day15 {
        enum Item {
            case sensor
            case beacon
            case none
        }
        
        let targetRow: Int
        let input: String
        var g: GridG<Point,Item> = GridG()
        
        /// - Attention: requires input alteration.
        /// I just removed all the strings. Turned into an array. 
        init(fileName: String = "day15", targetRow: Int = 2000000) {
            let reader = Reader(fileName: fileName)
            self.targetRow = targetRow
            input = reader.read()
        }
        
        func solve() -> Int {

            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                let items = line.components(separatedBy: ",").map { Int($0)!}
                let sensor = Point(x: items[0], y: items[1])
                let beacon = Point(x: items[2], y: items[3])
                
                markNoneBeaconsBasedOn(sensor, and: beacon)
            }
            
            return g.coordinates.filter { $0.value == .none}.count
        }
        func markNoneBeaconsBasedOn(_ sensor: Point, and beacon: Point) {
            g.set(sensor, to: .sensor)
            g.set(beacon, to: .beacon)
            
            let distance = sensor.manahattanDistance(with: beacon)
            
            // Using a set because I'm doing the point itself. And then 4 operations on it as well.
            var vectors: Set<Vector> = []
            /// - Note: Should not re-set a beacon or sensor location
            /// `i = 0` means all movement is vertical.
            for i in (0...distance) {
                for j in (0...(distance - i)) {
                    vectors.insert(Vector(x: i, y: j))
                    vectors.insert(Vector(x: i * -1, y: j))
                    vectors.insert(Vector(x: i, y: j * -1))
                    vectors.insert(Vector(x: i * -1, y: j * (-1)))
                }
            }
            
            for vector in vectors {
                let newPoint = Point(x: sensor.x + vector.x, y: sensor.y + vector.y)
//                print("newPoint:", newPoint)
                g.set(newPoint, to: .none, shouldOverride: false)
            }
//            print("------")
        }
    }
}

/// TBH not much different from a normal dictionary.
struct GridG<K: Hashable, V> {
    var coordinates: [K: V] = [:]
    
    mutating func set(_ point: K, to value: V, shouldOverride: Bool = true) {
        if shouldOverride {
            coordinates[point] = value
        } else if coordinates[point] == nil {
            coordinates[point] = value
        }
    }
}
