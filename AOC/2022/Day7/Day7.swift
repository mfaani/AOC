//
//  Day7.swift
//  AOC
//
//  Created by mfaani on 12/7/22.
//

import Foundation

/*
 $ cd /
 $ ls
 dir a
 14848514 b.txt
 8504156 c.dat
 dir d
 $ cd a
 $ ls
 dir e
 29116 f
 2557 g
 62596 h.lst
 $ cd e
 $ ls
 584 i
 $ cd ..
 $ cd ..
 $ cd d
 $ ls
 4060174 j
 8033020 d.log
 5626152 d.ext
 7214296 k
 
 process command
    determine where you are.
    process ls
        determine it's children.
        realize you're going down in a DFS way...
        sum of each dir is = some of files + some of dirs
    process

 Turn it into a tree first. Every node is the full path...
 
 */

enum Command: String {
    case cd
    case ls
}

extension Y2022 {
    struct Day7 {
        let reader = Reader(fileName: "day7-sample")
        var currentPath: URL = URL(string: "/")!
        var currentItems: [Item] = []
        var root: Directory
        mutating func solveA() {
            let input = reader.read()
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                let components = line.components(separatedBy: .whitespaces).filterOutEmpties()
                if components.first == "$" {
                    process(components)
                } else if components.first == "dir" {
                    
                }
            }
        }
        mutating func process(_ components: [String]) {
            if components[0] == "$" {
                processCommand(Array(components[1...]))
            }
        }
        
        mutating func processCommand(_ command: [String]) {
            if command.first == Command.cd.rawValue {
                changeDirectory(to: command.last!)
            } else if command.first == Command.ls.rawValue {
                // do nothing.
                // or enable read mode. 🤔
            } else {
                fatalError("wtf. we only have two commands")
            }
        }
        
        mutating func changeDirectory(to directory: String) {
            switch directory {
            case "..":
                currentPath.deleteLastPathComponent()
            case "/":
                break
            default:
                currentPath.appendPathComponent(directory)
            }
        }
    }
}

enum ResourceType {
    case dir
    case file
}

protocol Item {
    var type: ResourceType { get set }
}

struct Directory: Item {
    var type: ResourceType = .dir
    let path: URL
    var files: [File]
    var directories: [Directory]
    
    var fileSizes: Int {
        return files.map {$0.size}.reduce(0,+)
    }
    var size: Int {
        var sum = fileSizes
        for directory in directories {
            sum += directory.fileSizes
        }
        return sum
    }
}

struct File {
    var type: ResourceType = .file
    let name: String
    let size: Int
}