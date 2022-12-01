//
//  Day1.swift
//  AOC
//
//  Created by mfaani on 12/1/22.
//

import Foundation

struct Day1 {
    func solveA() -> Int {
        let reader = Reader(fileName: "day1")
        let inputs = reader.read()
        let calories = inputs.components(separatedBy: .newlines)
        var ans = 0
        var current = 0
        for calory in calories {
            if calory ==  "" {
                ans = max(ans, current)
                current = 0
                continue
            }
            current += Int(calory)!
        }
        return ans
    }
    
    func solveB() -> Int {
        let reader = Reader(fileName: "day1")
        let inputs = reader.read()
        let calories = inputs.components(separatedBy: .newlines)
        var answers: [Int] = []
        var current = 0
        for calory in calories {
            if calory ==  "" {
                answers.append(current)
                current = 0
                continue
            }
            current += Int(calory)!
        }
        let answer = answers.sorted(by: >)[0...2].reduce(0,+)
        return answer
    }
}
