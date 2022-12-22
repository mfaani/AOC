//
//  Reader.swift
//  AOC
//
//  Created by mfaani on 12/1/22.
//

import Foundation


struct Reader{
    let fileName: String
    let bundle = Bundle.main
    
    /// Reads from the input file. Removes my personal comments.
    /// - Parameter withTrimming: A Boolean indicated whether it should trim the beginning and end of entire conent.
    /// - Returns: returns original input. 
    func read(withTrimming: Bool = true) -> String {
        let inputURL = bundle.path(forResource: fileName, ofType: "txt")!
        let file = try! String(contentsOfFile: inputURL)
        
        /// - Attention: anything after 'mfaani' is considered notes for myself :D 
        if withTrimming {
            return file.trimmingCharacters(in: .whitespaces).components(separatedBy: "mfaani").first!
        } else {
            return file.components(separatedBy: "mfaani").first!
        }
    }
    
    // might be used later
    struct Column<T> {
        var one: T
        var two: T
    }
    
    func buildRowsAndColumns(withTrimming: Bool = true) -> Grid {
        var rows: [[Character]] = []
        var columns: [[Character]] = []
        let input = read(withTrimming: withTrimming)
        for line in input.components(separatedBy: .newlines).filterOutEmpties() {
            rows.append(Array(line))
        }
        var temp: [Character] = []
        for columnIndex in 0..<rows[1].count {
            for row in rows {
                temp.append(row[columnIndex])
            }
            columns.append(temp)
            temp.removeAll()
        }
        
        return Grid(rows: rows, columns: columns)
    }
}

struct Grid {
    let rows: [[Character]]
    let columns: [[Character]]
    
    var size: Size {
        return Size(x: columns.count, y: rows.count)
    }
}

extension Collection where Element: StringProtocol {
    func filterOutEmpties() -> [Element] {
        return self.filter { !$0.isEmpty }
    }
}


struct PGrid {
    
}
