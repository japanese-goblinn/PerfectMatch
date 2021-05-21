import Foundation
import ArgumentParser
import AppKit

extension String {
  internal func expandingTildeInPath() -> String {
    return NSString(string: self).expandingTildeInPath
  }
  
  internal mutating func expandTildeInPath() {
    self = NSString(string: self).expandingTildeInPath
  }
}

extension URL: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    guard let url = URL(string: value) else {
      fatalError("Invalid url")
    }
    self = url
  }
}

extension FileManager {
  internal func isDirectoryPath(_ path: String) throws -> Bool {
    var isDirectory: ObjCBool = true
    let isPathExists = fileExists(atPath: path, isDirectory: &isDirectory)
    if !isPathExists {
      throw CocoaError(.fileNoSuchFile)
    }
    return isDirectory.boolValue
  }
}

extension PerfectMatchCommand {
  internal enum Error: Swift.Error, LocalizedError {
    internal typealias Message = String
    
    case fileIsNotExist(Message)
    case isDirectory(Message)
    
    internal var errorDescription: String? {
      switch self {
      case .fileIsNotExist(let message): return message
      case .isDirectory(let message):    return message
      }
    }
  }
}

internal struct PerfectMatchCommand: ParsableCommand {
  internal static let configuration = CommandConfiguration(
    commandName: "perfect-match",
    abstract: "CLI tool to use PerfectMath app to check difference between two files"
  )
  
  @Argument(help: "First file to be compared")
  private var oldFile: String
  
  @Argument(help: "Second file to be compared")
  private var newFile: String
  
  internal func run() throws {
    let fileManager = FileManager.default
    let currentPath = fileManager.currentDirectoryPath
        
    var oldFilePath = currentPath.appending("/\(oldFile)")
    if !fileManager.fileExists(atPath: oldFilePath) {
      oldFilePath = oldFile.expandingTildeInPath()
    }
    var newFilePath = currentPath.appending("/\(newFile)")
    if !fileManager.fileExists(atPath: newFilePath) {
      newFilePath = newFile.expandingTildeInPath()
    }
    
    guard fileManager.fileExists(atPath: oldFilePath) else {
      throw Error.fileIsNotExist("⛔️ \"\(oldFile)\" is not exist")
    }
    guard try !fileManager.isDirectoryPath(oldFilePath) else {
      throw Error.isDirectory("⛔️ \"\(oldFile)\" is a directory")
    }
    guard fileManager.fileExists(atPath: newFilePath) else {
      throw Error.fileIsNotExist("⛔️ \"\(newFile)\" is not exist")
    }
    guard try !fileManager.isDirectoryPath(newFilePath) else {
      throw Error.isDirectory("⛔️ \"\(newFile)\" is a directory")
    }
    let urlSchemeLink = URL(
      stringLiteral: "perfectmatch://fileHandling?oldFile=\(oldFilePath)&newFile=\(newFilePath)"
    )
    let result = NSWorkspace.shared.open(urlSchemeLink)
    print(result ? "✅ Done" : "⛔️ Can't open PerfectMatch")
  }
}

PerfectMatchCommand.main()
