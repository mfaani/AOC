//
//  Day11.swift
//  AOC
//
//  Created by mfaani on 12/15/22.
//

import Foundation

extension Y2022 {
    struct Day11 {
        let reader = Reader(fileName: "day11")
        lazy var input = reader.read()
        let builder = MonkeyBuilder()
        let controller = Controller()
        
        mutating func solveA() -> Int {
            let segments = input.components(separatedBy: "\n\n")
            for monkeySegment in segments {
                let monkey = builder.build(str: monkeySegment)
                controller.monkies.append(monkey)
            }
            controller.start()
            return controller.business.map { $0.1 }.sorted().reversed().prefix(2).reduce(1, *)
        }
    }
}

struct MonkeyBuilder {
    
    func build(str: String) -> Monkey {
        let lines = str.components(separatedBy: .newlines).filterOutEmpties()
        let id = lines[0].description.components(separatedBy: .whitespaces).filterOutEmpties().last!.replacingOccurrences(of: ":", with: "")
        let items = lines[1].components(separatedBy:":").last!.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { Int($0)!}
        let operationLogicItems = lines[2].components(separatedBy: "=").last!.components(separatedBy: .whitespaces).filterOutEmpties()[1...]
        let divisor = Int(lines[3].components(separatedBy: .whitespaces).last!)!
        var throwTos = [lines[4].components(separatedBy: .whitespaces).last!]
        throwTos.append(lines[5].components(separatedBy: .whitespaces).last!)
        
        return Monkey(id: id, items: items, operationLogicItems: Array(operationLogicItems), divisor: divisor, throwTos: throwTos)
        
    }
}

struct Monkey {
    let id: String
    var items: [Int]
    var operationLogicItems: [String]
    var divisor: Int
    var throwTos: [String]
    
    // ONLY WORKS for part2. Part1, have to go back to a previous commit 🙈
    mutating func throwItems(_ productOfAllDivisors: Int) -> [Transfer] {
        var transfers: [Transfer] = []
        for item in items {
            
            let small = item % productOfAllDivisors
            let worryLevel = item.apply(Math.Operation(rawValue: operationLogicItems[0])!, with: Int(operationLogicItems[1]) ?? small)
            var index = 1
            if worryLevel % divisor == 0 {
                index = 0
            }
            let adjustedWorry = worryLevel % productOfAllDivisors
            let transfer = Transfer(monkeyId: throwTos[index], item: adjustedWorry)
            transfers.append(transfer)
        }
        items.removeAll()
        return transfers
    }
    
    mutating func acceptItems(num: Int) {
        items.append(num)
    }
}

struct Transfer {
    var monkeyId: String
    var item: Int
}

class Controller {
    var monkies: [Monkey] = []
    var business: [String: Int] = [:]
    lazy var productOfAllDivisors: Int = {
        return monkies.map {$0.divisor}.reduce(1, *)
    }()
    
    func start() {
        for _ in 0..<10000 {
            for i in 0..<monkies.count {
                let transfers = monkies[i].throwItems(productOfAllDivisors)
                business[monkies[i].id] = (business[monkies[i].id] ?? 0) + transfers.count
                for transfer in transfers {
                    let indexOfReceivingMonkey = Int(transfer.monkeyId)!
                    monkies[indexOfReceivingMonkey].acceptItems(num: transfer.item)
                }
            }
        }
    }
}


