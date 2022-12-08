//
//  Day7 + Models.swift
//  AOC
//
//  Created by mfaani on 12/7/22.
//

import Foundation

enum ResourceType {
    case dir
    case file
}

protocol Item {
    var type: ResourceType { get }
}

class Directory: Item {
    let type: ResourceType = .dir
    let path: URL
    var files: [File] = []
    var directories: [Directory] = []
    
    init(path: URL) {
        self.path = path
    }
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
    
    func addDirectory(_ directoryName: String, fromPath: URL) {
        if directoryName == "/" { return }
        // start from the root directory...
        var lookupDirectory: Directory? = self
        var wasFound = false
        for (i, segment) in fromPath.path.components(separatedBy: "/").filterOutEmpties().enumerated() {
            let found = lookupDirectory?.directories.first { directory in
                wasFound = true
                return directory.path.absoluteString.components(separatedBy: "/")[i] == segment
            }
            lookupDirectory = found
        }
        
        let newPath = fromPath.appendingPathComponent(directoryName)
        directories.append(Directory(path: newPath))
    }
    
    func addFile(_ fileName: String, with size: Int) {
        files.append(File(name: fileName, size: size))
    }
}

extension Directory: CustomDebugStringConvertible {
    var debugDescription: String {
        let names: [String] = files.map { $0.name }
        var directories: [String: [String]] = directories.reduce([:]) { partialResult, directory in
            var new = partialResult
            new[directory.path.lastPathComponent] = directory.directories.map {$0.debugDescription}
            return new
        }
        
        return "directory: \(path.lastPathComponent), files: \(names), directories: \(directories)"
    }
}

struct File {
    let type: ResourceType = .file
    let name: String
    let size: Int
}

enum Command: String {
    case cd
    case ls
}
