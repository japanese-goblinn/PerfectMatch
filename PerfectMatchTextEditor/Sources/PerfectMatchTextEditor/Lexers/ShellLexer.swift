import Foundation

public class ShellLexer: SourceCodeRegexLexer {
  
  public lazy var generators: [TokenGenerator] = {
    var generators = [TokenGenerator?]()
    
    return generators.compactMap { $0 }
  }()
  
  public func generators(source: String) -> [TokenGenerator] {
    return generators
  }
  
  public init() {}
  
}

