//
//  Day12.swift
//  AOC
//
//  Created by mfaani on 12/16/22.
//

import Foundation

/*
 aabqponm
 abcryxxl
 accszExk
 acctuvwj
 abdefghi
 */
extension Y2022 {
    struct Day12 {
        var reader = Reader(fileName: "day12-sample")
        lazy var gridInput = reader.buildRowsAndColumns()
        lazy var rows = gridInput.rows
        lazy var map = Map(grid: gridInput)
        
        mutating func solveA() -> Int {
//            map.start()
            map.breadthStart()
            return map.shortestPath
        }
        
        struct Elevation {
            var height: Character
            var visited = false
        }
        
        struct Map {
            var grid: Grid
            
            init(grid: Grid) {
                self.grid = grid
                var _dict: [Point: Elevation] = [:]
                for (ci, row) in grid.rows.enumerated() {
                    for (ri, char) in row.enumerated() {
                        let point = Point(x: ri, y: ci)
                        _dict.updateValue(Elevation(height: char), forKey: point)
                        if char == "S" {
                            startingPoint = point
                            startingNeighbors = point.positiveNeighbors
                        }
                    }
                }
                self.dict = _dict
            }
            
            var dict: [Point: Elevation]
            var startingPoint: Point = Point(x: 0, y: 0)
            var startingNeighbors: [Point] = []
            
            var visitedPoints: Set<Point> = []
            var shortestPath = Int.max
            
            mutating func breadthStart() {
                traverseB(level: [startingPoint], length: 0)
            }
            
            /// BFS vs DFS in **Graphs**: with BFS your next iteration is an level in the graph. WIth DFS, your next iteration is only a single node progress of a single path.
            /// This means the recursive function in BFS, takes an array, while with a DFS it takes a single node.
            mutating func traverseB(level: [Point], length: Int) {
                if shortestPath != Int.max {
                    return
                }
                var newNeighbors: [Point] = []
                let unvisited = level.filter ({ $0.x < grid.size.x && $0.y < grid.size.y && dict[$0]!.visited == false })
                for point in unvisited {
                    dict[point]?.visited = true
                    if dict[point]?.height == "E" {
                        shortestPath = length
                        break
                    }
                    for n in point.positiveNeighbors.filter ({ $0.x < grid.size.x && $0.y < grid.size.y && dict[$0]!.visited == false }) {
                        if canJump(from: point, to: n) {
                            newNeighbors.append(n)
                        }
                    }
                }
                traverseB(level: newNeighbors, length: length + 1)
            }
            
            mutating func start() {
                dict[startingPoint]!.visited = true
                traverse(point: startingPoint, length: 0)
            }
            
            mutating func traverse(point: Point, length: Int) {
                if dict[point]!.height == "E" {
                    shortestPath = min(shortestPath, length)
                }
                /// - NOTE: Accessing `dict[$0]!` is purposely the last condition. Because if the x or y are out of the grid then the dictionary lookup would crash.
                let univisited = point.positiveNeighbors.filter { $0.x < grid.size.x && $0.y < grid.size.y && dict[$0]!.visited == false }
                
                for n in univisited {
                    print("coord: \(point), height: \(dict[point]!), unvisited: \(univisited.map{ dict[$0]!.height}), length: \(length)")
                    let isNeighborJumpable = canJump(from: point, to: n)
                    if isNeighborJumpable {
                        dict[n]!.visited = true
                        traverse(point: n, length: length + 1)
                    }
                }
            }
            
            func canJump(from p1: Point, to p2: Point) -> Bool {
                let h1 = dict[p1]!.height == "S" ? "a" : dict[p1]!.height
                let h2 = dict[p2]!.height == "E" ? "z" : dict[p2]!.height
                
                if h1 >= h2 || h1.asciiValue! == (h2.asciiValue! - 1) {
                    return true
                } else {
                    return false
                }
            }
            
            mutating func movedTo(_ point: Point) {
                let h = dict[point]!.height
                dict.updateValue(Elevation(height: h, visited: true), forKey: point)
            }
        }
    }
}

private extension Point {
    // shouldn't be outside the positive edges
    var positiveNeighbors: [Point] {
        return straightNeighbors.filter { $0.x >= 0 && $0.y >= 0 }
    }
}

extension Point {
    var straightNeighbors: [Point] {
        return [Point(x: x + 1, y: y), Point(x: x - 1, y: y), Point(x: x, y: y + 1), Point(x: x, y: y - 1)]
    }
}
