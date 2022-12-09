//
//  Day8.swift
//  AOC
//
//  Created by mfaani on 12/9/22.
//

import Foundation

/*
 30373
 25512 i = 1, j = 3
 65332
 33549
 35390
 */

extension Y2022 {
    struct Day8 {
        let reader = Reader(fileName: "day8")
        var rows: [[Character]] = []
        var columns: [[Character]] = []
        lazy var input = reader.read()
        lazy var visibleCount = rows.count * 4 - 4
        
        mutating func solveA() -> Int{
            buildRowsAndColumns()
            print("count:", visibleCount)
            // Using zip, because when I used `enumerated` the index started from `0` which I didn't want. I could have hacked and just increased the index by 1, but not doing that...
            for (i,row) in zip(rows[1..<(rows.count - 1)].indices, rows[1..<(rows.count - 1)]) {
                for (j, column) in zip(columns[1..<(columns.count - 1)].indices, columns[1..<(columns.count - 1)]) {
                    if rows[i][j] > (row[..<j].max() ?? "-") || rows[i][j] > (row[(j + 1)...].max() ?? "-") || rows[i][j] > (column[..<i].max() ?? "-") || rows[i][j] > (column[(i + 1)...].max() ?? "-") {
                        print("item at row:", i, "col:", j,":", rows[i][j] , "was tall enough")
                        visibleCount += 1
                    } else {
                        print("item at row:", i, "col:", j,":", rows[i][j] , "wasn't tall enough")
                    }
                }
            }
            
            return visibleCount
        }
        
        mutating func buildRowsAndColumns() {
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                rows.append(Array(line))
            }
            var temp: [Character] = []
            for columnIndex in 0..<rows.count {
                for row in rows {
                    temp.append(row[columnIndex])
                }
                columns.append(temp)
                temp.removeAll()
            }
        }
    }
}
