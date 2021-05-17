import SwiftUI

extension Image {
  public init(systemSymbol: SFSymbol) {
    self = .init(systemName: systemSymbol.name)
  }
}

public extension SFSymbol {
  static var gearshapeFill: Self { .init(name: "gearshape.fill") }
}

public struct SFSymbol {
  public let name: String

  public init(name: String) {
    self.name = name
  }
}
