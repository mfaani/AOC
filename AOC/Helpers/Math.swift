//
//  Math.swift
//  AOC
//
//  Created by mfaani on 12/15/22.
//

import Foundation

struct Math {
    enum Operation: String {
        case plus = "+"
        case minus = "-"
        case multiply = "*"
        case divide = "/"
    }
}

extension Int {
    func apply(_ operation: Math.Operation, with num: Int) -> Int {
        switch operation {
        case .plus:
             return self + num
        case .minus:
            return self - num
        case .multiply:
            return self * num
        case .divide:
            return self / num
        }
}
}
