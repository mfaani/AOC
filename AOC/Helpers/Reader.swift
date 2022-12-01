//
//  Reader.swift
//  AOC
//
//  Created by Faani Tabrizi Nezhaad, Mohammad on 12/1/22.
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
    
//    func readX() -> String {
//        if let startWordsURL = Bundle.main.url(forResource: fileName, withExtension: "txt") { // FAILS HERE
//            if let startWords = try? String(contentsOf: startWordsURL) {
//                return startWords
//            }
//        }
//        fatalError()
//    }
}
