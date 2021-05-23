import Foundation

public class CLexer: SourceCodeRegexLexer {
  
  public lazy var generators: [TokenGenerator] = {
    var generators = [TokenGenerator?]()
    
    generators.append(regexGenerator("(\\n|^)#(include)\\s", tokenType: .identifier))
    generators.append(regexGenerator("\\b(printf)(?=\\()", tokenType: .identifier))
    generators.append(regexGenerator("\\.([A-Za-z_])+\\w*", tokenType: .identifier))
    generators.append(regexGenerator("(?<=(\\s|\\[|,|:))(\\d|\\.|_)+", tokenType: .number))
    // Line comment
    generators.append(regexGenerator("//(.*)", tokenType: .comment))
    // Block comment
    generators.append(
      regexGenerator("(/\\*)(.*)(\\*/)", options: [.dotMatchesLineSeparators], tokenType: .comment)
    )
    // Single-line string literal
    generators.append(regexGenerator("(\"|@\")[^\"\\n]*(@\"|\")", tokenType: .string))
    let keywords = "auto break case char const continue default do double else enum extern float for  goto if int long register return short signed sizeof static struct switch typedef union unsigned  void volatile while".components(separatedBy: .whitespaces)
    generators.append(keywordGenerator(keywords, tokenType: .keyword))
    return generators.compactMap { $0 }
  }()
  
  public func generators(source: String) -> [TokenGenerator] {
    return generators
  }
  
  public init() {}
  
}
