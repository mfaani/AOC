//
//  CharacterSet.swift
//  AOC
//
//  Created by mfaani on 12/3/22.
//

import Foundation
/// - Note: This is unused so far. 
let aScalars = "a".unicodeScalars
let aCode = aScalars[aScalars.startIndex].value

let lowercaseLetters: [Character] = (0..<26).map {
    i in Character(UnicodeScalar(aCode + i)!)
}

let AScalars = "A".unicodeScalars
let ACode = AScalars[AScalars.startIndex].value


let uppercaseLetters: [Character] = (0..<26).map {
    i in Character(UnicodeScalar(ACode + i)!)
}


