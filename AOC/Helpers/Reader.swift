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
    
    func read() -> String {
        let inputURL = bundle.path(forResource: fileName, ofType: "txt")!
        let file = try! String(contentsOfFile: inputURL)
        let trimmedInput = file.trimmingCharacters(in: .whitespaces)
        
        return trimmedInput
    }
    // might be used later
    struct Column<T> {
        var one: T
        var two: T
    }
}
