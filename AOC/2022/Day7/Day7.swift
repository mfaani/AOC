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

extension Y2022 {
    struct Day7 {
        let reader = Reader(fileName: "day7-sample")
        var currentPath: URL = URL(string: "/")!
        var root: Directory = Directory(path: URL(string: "/")!)
        let maxSize = 100000
        mutating func solveA() -> Int {
            let input = reader.read()
            buildTree(from: input)
            return countDirectoriesUnder(maxSize)
        }
        
        mutating func buildTree(from input: String) {
            for line in input.components(separatedBy: .newlines).filterOutEmpties() {
                print("line:", line)
                let components = line.components(separatedBy: .whitespaces).filterOutEmpties()
                if components.first == "$" {
                    process(components)
                } else if components.first == "dir" {
                    root.addDirectory(components.last!, fromPath: currentPath)
                    print(root)
                } else if let size = Int(components.first!) {
                    root.addFile(components.last!, with: size, fromPath: currentPath)
                    print(root)
                } else {
                    fatalError("wtf. there shouldn't be anything else left. ")
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
        
        mutating func countDirectoriesUnder(_ maxSize: Int) -> Int {
                        
            traverse(from: root, maxSize: maxSize)
            return total
        }
        var total = 0
        mutating func traverse(from dir: Directory, maxSize: Int) {
            let size = dir.totalSize
            if size < maxSize {
                print("goodSize:", size)
                total += size
            }
            
            for directory in dir.directories {
                traverse(from: directory, maxSize: maxSize)
            }
        }
    }
}
