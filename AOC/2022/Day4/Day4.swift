//
//  Day4.swift
//  AOC
//
//  Created by mfaani on 12/4/22.
//

import Foundation

/*
 2-4,6-8
 2-3,4-5
 5-7,7-9
 2-8,3-7
 6-6,4-6
 2-6,4-8
 */

extension Y2022 {
    struct Day4 {
        let reader = Reader(fileName: "day4")
        
        /// Returns the number of times the work contains the other work.
        func solveA() -> Int {
            let input = reader.read()
            var ans = 0
            
            input.components(separatedBy: .newlines).filter { !$0.isEmpty }.forEach { line in
                // read each line
                let sections = line.components(separatedBy: ",")
                let b1 = sections[0].components(separatedBy: "-")
                let b2 = sections[1].components(separatedBy: "-")
                let r1 = Int(String(b1.first!))!...Int(String(b1.last!))!
                let r2 = Int(String(b2.first!))!...Int(String(b2.last!))!
                if does(r1, contain: r2) || does(r2, contain: r1) {
                    ans += 1
                }
            }
            return ans
        }
        func does(_ r1:ClosedRange<Int>, contain r2: ClosedRange<Int>) -> Bool {
            if r1.contains(r2.first!) && r1.contains(r2.last!) {
                return true
            } else {
                return false
            }
        }
        
        /// Return the number of times the elf work overlaps
        func solveB() -> Int {
            let input = reader.read()
            var ans = 0
            
            input.components(separatedBy: .newlines).filter { !$0.isEmpty }.forEach { line in
                // read each line
                let sections = line.components(separatedBy: ",")
                let b1 = sections[0].components(separatedBy: "-")
                let b2 = sections[1].components(separatedBy: "-")
                let r1 = Int(String(b1.first!))!...Int(String(b1.last!))!
                let r2 = Int(String(b2.first!))!...Int(String(b2.last!))!
                if r1.overlaps(r2) {
                    ans += 1
                }
            }
            return ans
        }
    }
}
