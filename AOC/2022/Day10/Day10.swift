//
//  Day10.swift
//  AOC
//
//  Created by mfaani on 12/11/22.
//

import Foundation
/*
 noop
 addx 3
 addx -5
 mfaani

 read line
    if noop: process anything in leftover. add count
    if addx: process leftover; add to leftover
 
 */



extension Y2022 {
    struct Day10 {
        let reader = Reader(fileName: "day10")
        lazy var input = reader.read()
        var register = Register()
        var crt = CRT()
        
        mutating func solveA() -> Int{
        
            let lines = input.components(separatedBy: .newlines).filterOutEmpties()
            
            for line in lines {
                let components = line.components(separatedBy: .whitespaces).filterOutEmpties()
                if components.count == 2 {
                    register.processInstruction(num: Int(components[1])!)
                } else if components.count == 1 {
                    register.processNoop()
                }
            }
            print("signals:", register.signals)
            let everyFortySignalFrom60thCycle: Int = register.signals[2...].enumerated().filter { $0.0 % 2 == 0}.map { $0.1}.reduce(0, +)
            return register.signals.first! + everyFortySignalFrom60thCycle
        }

        
        mutating func solveB() -> String {
            let lines = input.components(separatedBy: .newlines).filterOutEmpties()
            
            for line in lines {
                print("line: \(line)")
                let components = line.components(separatedBy: .whitespaces).filterOutEmpties()
                if components.count == 2 {
                    crt.processInstruction(num: Int(components[1])!)
                } else if components.count == 1 {
                    crt.processNoop()
                }
            }
            
            return crt.canvas
        }
    }
}

struct Register {
    var signal = 0
    var cycle = 0 {
        didSet {
            if cycle % 20 == 0 {
                signal = sum * cycle
                signals.append(sum * cycle)
            }
        }
    }
    var signals: [Int] = []
    var sum = 1
    var leftoverWork: [Int] = []
    
    mutating func processInstruction(num: Int) {
        cycle += 1
        leftoverWork.append(num)
        
        cycle += 1
        sum += leftoverWork.removeLast()
    }
    
    mutating func processNoop() {
        cycle += 1
    }
}

struct CRT {
    
    var canvas: String = ""
    var spriteRange = 0...2
    var cycle = 0
    var sum = 1
    var leftoverWork: [Int] = []
    
    mutating func draw() {
        let position = (cycle - 1) % 40
        
        if spriteRange.contains(position) {
            canvas += "▮"
        } else {
            canvas += "."
        }
        if cycle % 40 == 0 {
            canvas += "\n"
        }
    }
    
    mutating func processInstruction(num: Int) {
        cycle += 1
        draw()
        leftoverWork.append(num)
        
        cycle += 1
        sum += leftoverWork.removeLast()
        let middle = sum
        draw()
        spriteRange = (middle - 1)...(middle + 1)
    }
    
    mutating func processNoop() {
        cycle += 1
        draw()
        
    }
}

/*
 For certain parts of code, order matters.
 For others it doesn't.
 
 You might accidentally sweat over it — for steps that don't matter. Might also ignore it for steps that do matter.
 
 You'll master this over time.
 */
