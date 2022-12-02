//
//  Day2.swift
//  AOC
//
//  Created bymfaani on 12/2/22.
//

import Foundation

struct Day2 {
    enum Choice: Int, Comparable, CaseIterable {
        case rock = 1
        case paper = 2
        case scissors = 3
        
        static func <(lhs: Choice, rhs: Choice) -> Bool {
            switch (lhs, rhs) {
            case (.rock, .paper), (.paper, .scissors), (.scissors, .rock):
                return true
            default:
                return false
            }
        }
        
        func getScore(vs opponent: Choice) -> Int {
            var points = self.rawValue
            
            if self == opponent {
                points += 3
            } else if self > opponent {
                points += 6
            }
            return points
        }
    }
    
    let mapChoice: [Character: Choice] = ["A": .rock, "B": .paper, "C" : .scissors, "Y": .paper, "X": .rock, "Z": .scissors]

    func solveA() -> Int {
        let reader = Reader(fileName: "day2")
        let inputs = reader.read()
        var points = 0
        
        inputs.components(separatedBy: .newlines).filter { !$0.isEmpty }.forEach{
            let opponent = mapChoice[$0.first!]!
            let me = mapChoice[$0.last!]!
            
            points += me.getScore(vs: opponent)
        }
        return points
    }
    enum Outcome {
        case win
        case lose
        case draw
        
        var points: Int {
            switch self {
            case .win: return 6
            case .draw: return 3
            case .lose: return 0
            }
        }
        
        func decideMyChoice(vs opponent: Choice) -> Choice {
            switch (self) {
            case .win:
//                if opponent == .rock {
//                    return .paper
//                } else if opponent == .paper {
//                    return .scissors
//                } else {
//                    return .rock
//                }
                return Choice.allCases.first(where: {$0 > opponent})!
                
            case .draw:
                return opponent
            case .lose:
                return Choice.allCases.first(where: {$0 < opponent})!
            }
        }
    }
    
    var mapOutcome: [Character: Outcome] = ["X" : .lose, "Y" : .draw, "Z" : .win]
    
    //  X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"
    
    func solveB() -> Int {
        let reader = Reader(fileName: "day2")
        let inputs = reader.read()
        var points = 0
        
        inputs.components(separatedBy: .newlines).filter { !$0.isEmpty }.forEach{
            let opponent = mapChoice[$0.first!]!
            let outcome = mapOutcome[$0.last!]!
            
            points += outcome.points
            points += outcome.decideMyChoice(vs: opponent).rawValue
        }
        return points
    }
}
/*
 
 X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"
 A Y
 B X
 C Z
 */
