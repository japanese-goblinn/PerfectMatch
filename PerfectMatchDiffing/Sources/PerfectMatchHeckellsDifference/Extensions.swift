extension Collection {
  @inlinable
  public var isNotEmpty: Bool { !isEmpty }
}

public enum Either<T, U> {
  case left(T)
  case right(U)
}

extension Collection where Element: Hashable {
  @inlinable
  public func differ(from new: Self) -> HeckellsDifference<Self> {
    return .init(of: self, and: new)
  }
}

