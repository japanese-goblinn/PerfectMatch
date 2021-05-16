import SwiftUI

extension Image {
  init(systemSymbol: SFSymbol) {
    self = .init(systemName: systemSymbol.rawValue)
  }
}

enum SFSymbol: String {
  case gearshapeFill = "gearshape.fill"
}
