import SwiftUI

public extension SFSymbol {
  @inlinable static var gearshape: Self { .init(name: "gearshape") }
  @inlinable static var textAlignedLeft: Self { .init(name: "text.alignleft") }
  @inlinable static var xmarkSquare: Self { .init(name: "xmark.square") }
  @inlinable static var docText: Self { .init(name: "doc.text") }
  @inlinable static var xmarkCircle: Self { .init(name: "xmark.circle") }
  @inlinable static var xmark: Self { .init(name: "xmark") }
}

#warning("Potential error. Can be applied to symbols that did not have filled version")
public extension SFSymbol {
  @inlinable
  func filled() -> Self {
    return .init(name: name.appending(".fill"))
  }
}

public struct SFSymbol {
  public let name: String

  public init(name: String) {
    self.name = name
  }
}

public extension Image {
  init(systemSymbol: SFSymbol) {
    self = .init(systemName: systemSymbol.name)
  }
}
