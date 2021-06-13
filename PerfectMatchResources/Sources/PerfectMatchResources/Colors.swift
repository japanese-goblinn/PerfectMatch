import AppKit
import SwiftUI
import Foundation

public extension ColorResource {
  static var primaryGreen: Self { .init(name: "PrimaryGreen", bundle: .module) }
  static var primaryRed: Self { .init(name: "PrimaryRed", bundle: .module) }
  static var darkThemeBackground: Self { .init(name: "DarkThemeBackground", bundle: .module) }
}

public extension Color {
  @inlinable
  static func asset(_ color: ColorResource) -> Self {
    return .init(color.name, bundle: color.bundle)
  }
}

public extension NSColor {
  @inlinable
  static func asset(_ color: ColorResource) -> NSColor {
    return .init(named: color.name, bundle: color.bundle)!
  }
  
  @inlinable
  static func asset(_ color: ColorResource, alpha: CGFloat) -> NSColor {
    return .init(named: color.name, bundle: color.bundle)!
      .withAlphaComponent(alpha)
  }
}

public struct ColorResource {
  public let name: String
  public let bundle: Bundle

  internal init(name: String, bundle: Bundle) {
    self.name = name
    self.bundle = bundle
  }
}
