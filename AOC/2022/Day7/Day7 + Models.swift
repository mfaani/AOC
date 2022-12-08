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
    
    /// finds correct directory based on path
    /// adds new directory to that correct directory
    /// - Example:
    /// So fromPath would be something like: `/aaa/bbb`
    /// We want to then add 'ccc' onto it and turn it into `/aaa/bbb/ccc`
    ///
    func addDirectory(_ directoryName: String, fromPath: URL) {
        if directoryName == "/" { return }
        // start from the root directory...
        var lookupDirectory: Directory = self
        print("currentPath:", fromPath)
        for (i, segment) in fromPath.path.components(separatedBy: "/").filterOutEmpties().enumerated() {
            let found = lookupDirectory.directories.first { directory in
                return directory.path.absoluteString.components(separatedBy: "/").filterOutEmpties()[i] == segment
            }!
            lookupDirectory = found
        }
        
        lookupDirectory.directories.append(Directory(path: fromPath.appendingPathComponent(directoryName)))
    }
    
    func addFile(_ fileName: String, with size: Int, fromPath: URL) {
        var lookupDirectory: Directory = self
        print("currentPath:", fromPath)
        for (i, segment) in fromPath.path.components(separatedBy: "/").filterOutEmpties().enumerated() {
            let found = lookupDirectory.directories.first { directory in
                return directory.path.absoluteString.components(separatedBy: "/").filterOutEmpties()[i] == segment
            }!
            lookupDirectory = found
        }
        lookupDirectory.files.append(File(name: fileName, size: size))
    }
}

// I expect that after the 4th time of addFile.append, I'd see root.directories[0].files I should file f & g

/// This isn't perfect, but it works to some extent. 
extension Directory: CustomDebugStringConvertible {
    var debugDescription: String {
        let names: [String] = files.map { $0.name }
        let directories: [String: [String]] = directories.reduce([:]) { result, directory in
            var result = result
            result[directory.path.lastPathComponent] = directory.directories.map {$0.debugDescription} + directory.files.map { $0.name }
            return result
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
