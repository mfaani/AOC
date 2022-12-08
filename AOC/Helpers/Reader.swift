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
    
    func read(withTrimming: Bool = true) -> String {
        let inputURL = bundle.path(forResource: fileName, ofType: "txt")!
        let file = try! String(contentsOfFile: inputURL)
        let trimmedInput = file.trimmingCharacters(in: .whitespaces)
        
        
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
}

extension Collection where Element: StringProtocol {
    func filterOutEmpties() -> [Element] {
        return self.filter { !$0.isEmpty }
    }
}
