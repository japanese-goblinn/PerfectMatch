extension Collection {
  @inlinable
  internal var isNotEmpty: Bool { !isEmpty }
}

@usableFromInline
internal enum Either<T, U> {
  case left(T)
  case right(U)
}

extension Collection where Element: Hashable {
  @inlinable
  public func differ(from new: Self) -> HeckellsDifference<Self> {
    return .init(of: self, and: new)
  }
}

