//
//  2022 + Day3.swift
//  AOC
//
//  Created by mfaani on 12/3/22.
//

import Foundation

struct Y2022 {}

extension Y2022 {
    struct Day3 {
        let reader = Reader(fileName: "day3")
        
        /// Splits every line in half. Finds identical character in every split.
        /// Returns sum of the value of every identical character of every line.
        func solveA() -> Int {
            let inputs = reader.read()
            var ans = 0
            
            inputs.components(separatedBy: .newlines).filter { !$0.isEmpty }.forEach {
                // split string
                let characters = Array($0)
                // make dict
                var fHalf: Set<Character> = []
                var sHalf: Set<Character> = []
                
                for i in 0..<characters.count / 2 {
                    fHalf.insert(characters[i])
                }
                for i in (characters.count / 2)..<characters.count {
                    sHalf.insert(characters[i])
                }
                // intersect dict
                let character = fHalf.intersection(sHalf).first!
                
                // get value of dict
                ans += getValueOf(character)
            }
            return ans
        }
        
        func getValueOf(_ character: Character) -> Int {
            let base = character.isUppercase ? 26 : 0
            let lower = Character(character.lowercased())
            
            return Int(lower.asciiValue!) - 96 + base
        }
        /// Find identical character in every 3 lines.
        /// Return sum of the value of the identical character. Every 3 lines have one identical character.
        func solveB() -> Int {
            
            let input = reader.read()
            var ans = 0
            var index = 0
            var line1: Set<Character> = []
            var line2: Set<Character> = []
            var line3: Set<Character> = []
            var shouldReset = false
            input.components(separatedBy: .newlines).filter { !$0.isEmpty }.forEach {
                
                if index % 3 == 0 {
                    line1 = Set($0)
                }
                if index % 3 == 1 {
                    line2 = Set($0)
                }
                if index % 3 == 2 {
                    line3 = Set($0)
                    shouldReset = true
                }
                if shouldReset {
                    let character = line1.intersection(line2).intersection(line3).first!
                    shouldReset = false
                    ans += getValueOf(character)
                }
                index += 1
            }
            return ans
        }
    }
}
