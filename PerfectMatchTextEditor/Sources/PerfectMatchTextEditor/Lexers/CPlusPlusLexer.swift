import Foundation

public class CPlusPlusLexer: SourceCodeRegexLexer {
  
  public lazy var generators: [TokenGenerator] = {
    var generators = [TokenGenerator?]()
    
    generators.append(regexGenerator("(\\n|^)#(include)\\s", tokenType: .identifier))
    // #include <vector>
    generators.append(
      regexGenerator(#"\<([a-zA-Z]*)\>"#, tokenType: .string)
    )
    generators.append(regexGenerator("\\b(printf)(?=\\()", tokenType: .identifier))
    generators.append(regexGenerator("\\.([A-Za-z_])+\\w*", tokenType: .identifier))
    generators.append(regexGenerator("(?<=(\\s|\\[|,|:))(\\d|\\.|_)+", tokenType: .number))
    // Line comment
    generators.append(regexGenerator("//(.*)", tokenType: .comment))
    // Block comment
    generators.append(
      regexGenerator(
        "(/\\*)(.*)(\\*/)",
        options: [.dotMatchesLineSeparators],
        tokenType: .string
      )
    )
    // Single-line string literal
    generators.append(
      regexGenerator("(\"|@\")[^\"\\n]*(@\"|\")", tokenType: .string)
    )
    let keywords = "alignas alignof and and_eq asm atomic_cancel atomic_commit atomic_noexcept auto bitand bitor bool break case catch char char8_t char16_t char32_t class compl concept const consteval constexpr constinit const_cast continue co_await co_return co_yield decltype default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new noexcept not not_eq nullptr operator or or_eq private protected public reflexpr register reinterpret_cast requires return short signed sizeof static static_assert static_cast struct switch synchronized template this thread_local throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while xor cout endl xor_eq".components(separatedBy: .whitespaces)
    generators.append(keywordGenerator(keywords, tokenType: .keyword))
    
    return generators.compactMap { $0 }
  }()
  
  public func generators(source: String) -> [TokenGenerator] {
    return generators
  }
  
  public init() {}
}
