//
//  Day13.swift
//  AOC
//
//  Created by mfaani on 12/19/22.
//

import Foundation


extension Y2022 {
    struct Day13 {
        var reader = Reader(fileName: "day13-sample")
        lazy var input = reader.read()
        let decoder = JSONDecoder()
        var count = 0
        var pairNum = 0
        mutating func solve() -> Int {
            for pair in input.components(separatedBy: "\n\n") {
                pairNum += 1
                let pair = pair.components(separatedBy: .newlines).filterOutEmpties()
                let p1 = try! decoder.decode(Packet.self, from: pair[0].data(using: .utf8)!)
                let p2 = try! decoder.decode(Packet.self, from: pair[1].data(using: .utf8)!)
                if p2 >= p1 {
                    count += pairNum
                }
            }
            return count
        }
    }
    
    indirect enum Packet: Decodable, Comparable {
        static func < (lhs: Y2022.Packet, rhs: Y2022.Packet) -> Bool {
            switch (lhs, rhs) {
            case let (.value(signal1), .value(signal2)):
                return signal1 < signal2 // two ints
            case let (.list(packet1), .list(packet2)):
                
                /// When it comes to comparing `[[]]` vs `[]`, it's not it goes through another iteration to compare `[]` vs ` `. It's much like comparing `[2]` vs `[]`. The only difference is that for one the element is `Array<Packet>`, for the other the element is `Int`.
                /// The reason this is confusing is because you see an array and you think it will have to compare again. Yet the elements are an array itself. And an empty array is always smaller than an array that has an element (with another `Array` or `Int`)
                return packet1.lexicographicallyPrecedes(packet2)
            case (.list, .value):
                return lhs < .list([rhs])
            case (.value, .list):
                return .list([lhs]) < rhs
            }
        }
        
        case list([Packet])
        case value(Int)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            // tldr: It's recursive. But not endless. it ends when you container is not a list...
            do {
                self = try Packet.value(container.decode(Int.self))
            } catch {
                self = try! Packet.list(container.decode([Packet].self))
            }
        }
        
        
    }
}

