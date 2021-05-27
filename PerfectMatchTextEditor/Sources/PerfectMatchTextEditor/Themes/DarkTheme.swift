//
//  DefaultSourceCodeTheme.swift
//  SourceEditor
//
//  Created by Louis D'hauwe on 24/07/2018.
//  Copyright © 2018 Silver Fox. All rights reserved.
//

import Foundation
import PerfectMatchResources

internal extension Color {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
  }
}

public struct LightTheme: SourceCodeTheme {
  #warning("TODO: provide styles for gutter")
  public let lineNumbersStyle: LineNumbersStyle? = nil
  public let gutterStyle: GutterStyle = .init(backgroundColor: .clear, minimumWidth: 0)
  
  public let font: Font = .init(name: "SF Mono", size: 13)!
  
  public let backgroundColor: Color = .white
  
  public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
    switch syntaxColorType {
    case .plain:             return .init(r: 27, g: 31, b: 34)
    case .number:            return .init(r: 4, g: 50, b: 129)
    case .string:            return .init(r: 71, g: 28, b: 146)
    case .identifier:        return .init(r: 129, g: 93, b: 3)
    case .keyword:           return .init(r: 203, g: 35, b: 57)
    case .comment:           return .init(r: 87, g: 96, b: 106)
    case .editorPlaceholder: return .init(r: 87, g: 96, b: 106)
    }
  }
  
  public init() {}
}

public struct DarkTheme: SourceCodeTheme {
  #warning("TODO: provide styles for gutter")
  public let lineNumbersStyle: LineNumbersStyle? = nil
  public let gutterStyle: GutterStyle = .init(backgroundColor: .clear, minimumWidth: 0)
  
  public let font: Font = .init(name: "SF Mono", size: 13)!
  
  public let backgroundColor: Color = .asset(.darkThemeBackground)
  
  public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
    switch syntaxColorType {
    case .plain:             return .init(r: 218, g: 221, b: 226)
    case .number:            return .init(r: 104, g: 167, b: 255)
    case .string:            return .init(r: 142, g: 190, b: 255)
    case .identifier:        return .init(r: 220, g: 201, b: 104)
    case .keyword:           return .init(r: 245, g: 92, b: 112)
    case .comment:           return .init(r: 131, g: 139, b: 148)
    case .editorPlaceholder: return .init(r: 131, g: 139, b: 148)
    }
  }
  
  public init() {}
}
