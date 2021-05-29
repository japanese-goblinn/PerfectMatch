import AppKit
import SwiftUI
import Foundation

public extension ColorResource {
  @inlinable static var primaryGreen: Self { .init(name: "PrimaryGreen") }
  @inlinable static var primaryRed: Self { .init(name: "PrimaryRed") }
  @inlinable static var darkThemeBackground: Self { .init(name: "DarkThemeBackground") }
}

public extension Color {
  static func asset(_ color: ColorResource) -> Self {
    return .init(color.name, bundle: .module)
  }
}

public extension NSColor {
  static func asset(_ color: ColorResource) -> NSColor {
    return .init(named: color.name, bundle: .module)!
  }
  
  static func asset(_ color: ColorResource, alpha: CGFloat) -> NSColor {
    return .init(named: color.name, bundle: .module)!.withAlphaComponent(alpha)
  }
}

public struct ColorResource {
  public let name: String

  @usableFromInline
  internal init(name: String) {
    self.name = name
  }
}
