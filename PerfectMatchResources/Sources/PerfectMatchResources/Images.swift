import SwiftUI

extension Image {
  public init(systemSymbol: SFSymbol) {
    self = .init(systemName: systemSymbol.name)
  }
}

public extension SFSymbol {
  static var gearshapeFill: Self { .init(name: "gearshape.fill") }
  static var textAlignedLeft: Self { .init(name: "text.alignleft") }
  static var xmarkSquareFill: Self { .init(name: "xmark.square.fill") }
  static var doc: Self { .init(name: "doc") }
}

public struct SFSymbol {
  public let name: String

  public init(name: String) {
    self.name = name
  }
}
