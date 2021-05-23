import Foundation

public class ShellLexer: SourceCodeRegexLexer {
  
  public lazy var generators: [TokenGenerator] = {
    var generators = [TokenGenerator?]()
  
    let keywords = "exit set local if then else elif fi case esac for select while until do done in function time coproc".components(separatedBy: .whitespaces)
    generators.append(keywordGenerator(keywords, tokenType: .keyword))
    generators.append(regexGenerator("\\b(echo|printf)", tokenType: .identifier))
    // Digits
    generators.append(
      regexGenerator("(?<=(\\s|\\[|,|:))(\\d|\\.|_)+", tokenType: .number)
    )
    // Line comment
    generators.append(regexGenerator("\\#(\\s|\\!)(.*)", tokenType: .comment))
    // Single-line string literal
    generators.append(regexGenerator("(\"|@\")[^\"\\n]*(@\"|\")", tokenType: .string))
    
    
    return generators.compactMap { $0 }
  }()
  
  public func generators(source: String) -> [TokenGenerator] {
    return generators
  }
  
  public init() {}
  
}

