//
//  SavannaKit+Swift.swift
//  SourceEditor
//
//  Created by Louis D'hauwe on 24/07/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import Foundation

public protocol SourceCodeRegexLexer: RegexLexer {}

extension RegexLexer {
  public func regexGenerator(
    _ pattern: String,
    options: NSRegularExpression.Options = [],
    transformer: @escaping (_ range: Range<String.Index>) -> Token
  ) -> TokenGenerator? {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
      return nil
    }
    return .regex(.init(regularExpression: regex, tokenTransformer: transformer))
  }
  
}

extension SourceCodeRegexLexer {
  
  public func regexGenerator(
    _ pattern: String,
    options: NSRegularExpression.Options = [],
    tokenType: SourceCodeTokenType
  ) -> TokenGenerator? {
    return regexGenerator(pattern, options: options) { range -> Token in
       SimpleSourceCodeToken(type: tokenType, range: range)
    }
  }
  
  public func keywordGenerator(
    _ words: [String],
    tokenType: SourceCodeTokenType
  ) -> TokenGenerator {
    return .keywords(.init(keywords: words) { range -> Token in
       SimpleSourceCodeToken(type: tokenType, range: range)
    })
  }
}
