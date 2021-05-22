//
//  DefaultSourceCodeTheme.swift
//  SourceEditor
//
//  Created by Louis D'hauwe on 24/07/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import Foundation

public struct DefaultSourceCodeTheme: SourceCodeTheme {
  
  private static var lineNumbersColor: Color {
    .init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
  }
  
  public let lineNumbersStyle: LineNumbersStyle? = .init(
    font: .init(name: "Menlo", size: 14)!,
    textColor: lineNumbersColor
  )
  
  public let gutterStyle: GutterStyle = .init(
    backgroundColor: .init(red: 21/255.0, green: 22/255, blue: 31/255, alpha: 1.0),
    minimumWidth: 32
  )
  
  public let font: Font = .init(name: "SF Mono", size: 13)!
  
  public let backgroundColor: Color = .init(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)
  
  public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
    switch syntaxColorType {
    case .plain:      return .white
    case .number:     return .init(red: 116/255, green: 109/255, blue: 176/255, alpha: 1.0)
    case .string:     return .init(red: 211/255, green: 35/255, blue: 46/255, alpha: 1.0)
    case .identifier: return .init(red: 20/255, green: 156/255, blue: 146/255, alpha: 1.0)
    case .keyword:    return .init(red: 215/255, green: 0, blue: 143/255, alpha: 1.0)
    case .comment:    return .init(red: 69.0/255.0, green: 187.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    case .editorPlaceholder: return .init(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)
    }
  }
  
  public init() {}
}
