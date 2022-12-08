//
//  Day5.swift
//  AOC
//
//  Created by mfaani on 12/5/22.
//

import Foundation

/*
     [D]
 [N] [C]
 [Z] [M] [P]
 0   1   2
 
 move 1 from 2 to 1
 move 3 from 1 to 3
 move 2 from 2 to 1
 move 1 from 1 to 2

 */

extension Y2022 {
    struct Day5 {
        let reader = Reader(fileName: "day5")
        var columns: [[Character]] = []
        
        /// Returns All top crates
        mutating func solveA() -> String {
            let input = reader.read(withTrimming: false)
            
            let sections = input.components(separatedBy: "\n\n")
            let cratesInput = sections.first!
            let instructionsInput = sections.last!
            
            /// SETUP
            createColumns(from: cratesInput)
            reverseColumns()
            
            /// APPLY INSTRUCTIONS
            readAndApply(instructionsInput)
            
            // Reduce columns to sum of their top crates
            return columns.reduce(String("")) { partialResult, column in
                guard let top = column.last else {
                    return partialResult
                }
                return partialResult.appending(String(top))
            }
        }
        
        /*
             [D]
         [N] [C]
         [Z] [M] [P]
         0   1   2
         
         move 1 from 2 to 1
         move 3 from 1 to 3
         move 2 from 2 to 1
         move 1 from 1 to 2
         */
        mutating func createColumns(from input: String) {
            let lines = input.components(separatedBy: "\n")
            let columnCount: Int = Int(lines.last!.components(separatedBy: .whitespaces).filterOutEmpties().last!)!
            columns = Array(repeating: [], count: columnCount)
            
            for line in lines[...(lines.count - 2)] {
                let characters = Array(line)
                for i in characters.indices {
                    if i % 4 == 1 && !CharacterSet.whitespaces.contains(characters[i].unicodeScalars.first!) {
                        columns[i / 4].append(characters[i])
//                        print("line:", line, "\n", "columns:\n", columns)
                    }
                }
            }
        }
        
        mutating func reverseColumns() {
            var temp: [[Character]] = []
            columns.forEach {
                temp.append($0.reversed())
            }
            columns = temp
        }
        
        
        /*
         move 1 from 2 to 1
         move 3 from 1 to 3
         move 2 from 2 to 1
         move 1 from 1 to 2
         */
        mutating func readAndApply(_ instructions: String) {
            let instructionsArray = instructions.split(separator: "\n")
            
            var importantNumbers: [Int] = []
            instructionsArray.forEach {
                let nums = $0.components(separatedBy: CharacterSet.decimalDigits.inverted).filterOutEmpties().map { Int($0)!}
                importantNumbers = nums
                moveBatch(amount: importantNumbers[0], from: importantNumbers[1] - 1, to: importantNumbers[2] - 1)
            }
        }
        
        mutating func move(amount: Int, from c1: Int, to c2: Int) {
            for _ in 1...amount {
                print(columns, amount, c1, c2)
                columns[c2].append(columns[c1].popLast()!)
                print(columns)
                print("----")
            }
        }
        
        mutating func moveBatch(amount: Int, from c1: Int, to c2: Int) {
            print(columns, amount, c1, c2)
            columns[c2].append(contentsOf: columns[c1][columns[c1].count - amount..<columns[c1].count])
            columns[c1].removeLast(amount)
            print(columns)
            print("----")
            
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


/// DOES NOT WORK - BECAUSE YOU HAVE TO USE **SPACING** TO KNOW WHERE EACH COLUMN IS
extension Y2022.Day5 {
    /// Read line by line
    /// Place each item in the column.
    /// NOTE: top item will be first item of each column. Maybe I can reverse each array.

//    mutating func createColumns(from input: String) -> [[String]] {
//        let lines = input.components(separatedBy: "\n")
//
//        for line in lines[...(lines.count - 2)] {
//            let crates = line.components(separatedBy: .whitespaces)
//            for (j,crate) in crates.enumerated() {
//                if columns[safe: j] == nil {
//                    columns.append([crate])
//                } else {
//                    columns[j].append(crate)
//                }
//            }
//        }
//
//        return columns
//    }
}
