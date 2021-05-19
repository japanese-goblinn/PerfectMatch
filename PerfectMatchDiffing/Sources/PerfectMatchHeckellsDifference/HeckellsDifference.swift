import Foundation

public struct HeckellsDifference<
  DiffableCollection: Collection
> where
  DiffableCollection.Element: Hashable
{
  @usableFromInline
  internal typealias Index = Int
  
  @usableFromInline
  private(set) var moves = [Move]()
  
  @inlinable
  public init(of old: DiffableCollection, and new: DiffableCollection) {
    if old.isEmpty, new.isEmpty {
      return
    }
    /// `indices` used here for the sake of performance
    if old.isNotEmpty, new.isEmpty {
      for (i, _) in old.indices.enumerated() {
        moves.append(.delete(i))
      }
      return
    }
    /// `indices` used here for the sake of performance
    if old.isEmpty, new.isNotEmpty {
      for (i, _) in new.indices.enumerated() {
        moves.append(.insert(i))
      }
      return
    }
    if old.elementsEqual(new) {
      return
    }
    
    let oldCount = old.count
    var table = [DiffableCollection.Element: ElementEntry](minimumCapacity: oldCount)
    var oa = [Either<Unmanaged<ElementEntry>, Index>]()
    oa.reserveCapacity(oldCount)
    var na = [Either<Unmanaged<ElementEntry>, Index>]()
    na.reserveCapacity(new.count)
    
    /// 1
    for element in new {
      let entry: ElementEntry
      if let existingEntry = table[element] {
        entry = existingEntry
      } else {
        entry = .init()
        table[element] = entry
      }
      entry.elementOcurrencesInN.increment()
      na.append(.left(.passUnretained(entry)))
    }
    
    /// 2
    /// not updating table element if element already exists in it is more efficient
    for (index, element) in old.enumerated() {
      if let existingEntry = table[element] {
        existingEntry.elementOcurrencesInO.increment()
        existingEntry.elementNumberInO.push(index)
        oa.append(.left(.passUnretained(existingEntry)))
      } else {
        let entry = ElementEntry()
        entry.elementOcurrencesInO.increment()
        entry.elementNumberInO.push(index)
        oa.append(.left(.passUnretained(entry)))
        table[element] = entry
      }
    }
        
    /// 3
    for (index, either) in na.enumerated() {
      guard
        case .left(let entry) = either,
        entry._withUnsafeGuaranteedRef({ $0.elementOcurrencesInN == .one }),
        entry._withUnsafeGuaranteedRef({ $0.elementOcurrencesInO == .one }),
        let elementNumberInO = entry._withUnsafeGuaranteedRef({ $0.elementNumberInO.pop() })
      else { continue }
      na[index] = .right(elementNumberInO)
      oa[elementNumberInO] = .right(index)
    }
    
    /// 4
    var i = 1
    while i < na.count - 1 {
      defer { i += 1 }
      guard
        case .right(let j) = na[i],
        j + 1 < oa.count,
        case .left(let newEntry) = na[i + 1],
        case .left(let oldEntry) = oa[j + 1],
        newEntry._withUnsafeGuaranteedRef({ $0 }) === oldEntry._withUnsafeGuaranteedRef({ $0 })
      else { continue }
      na[i + 1] = .right(j + 1)
      oa[j + 1] = .right(i + 1)
    }
    
    /// 5
    i = na.endIndex - 1
    while i > 0 {
      defer { i -= 1 }
      guard
        case .right(let j) = na[i],
        j - 1 >= 0,
        case .left(let newEntry) = na[i - 1],
        case .left(let oldEntry) = oa[j - 1],
        newEntry._withUnsafeGuaranteedRef({ $0 }) === oldEntry._withUnsafeGuaranteedRef({ $0 })
      else { continue }
      na[i - 1] = .right(j - 1)
      oa[j - 1] = .right(i - 1)
    }
    
    /// final step
    var deleteOffsets = Array(repeating: 0, count: old.count)
    var offset = 0
    for (index, element) in oa.enumerated() {
      deleteOffsets[index] = offset
      if case .left = element {
        moves.append(.delete(index))
        offset += 1
      }
    }
    offset = 0
    for (index, element) in na.enumerated() {
      switch element {
      case .left:
        moves.append(.insert(index))
        offset += 1
        
      case .right(let oldIndex):
        let oldCollectionIndex = old.index(old.startIndex, offsetBy: oldIndex)
        let newCollectionIndex = new.index(new.startIndex, offsetBy: index)
        if old[oldCollectionIndex] != new[newCollectionIndex] {
          moves.append(.update(index))
        }
        if (oldIndex - deleteOffsets[oldIndex] + offset) != index {
          moves.append(.move(from: oldIndex, to: index))
        }
      }
    }
  }
  
}


extension HeckellsDifference {
  @usableFromInline
  internal class ElementEntry {
    @usableFromInline
    internal var elementOcurrencesInO: ElementOcurrence = .zero
    
    @usableFromInline
    internal var elementOcurrencesInN: ElementOcurrence = .zero
    
    @usableFromInline
    internal var elementNumberInO: Queue<Index> = []
    
    @usableFromInline
    internal init(elementOcurrencesInO: HeckellsDifference<DiffableCollection>.ElementOcurrence = .zero, elementOcurrencesInN: HeckellsDifference<DiffableCollection>.ElementOcurrence = .zero, elementNumberInO: Queue<HeckellsDifference<DiffableCollection>.Index> = []) {
      self.elementOcurrencesInO = elementOcurrencesInO
      self.elementOcurrencesInN = elementOcurrencesInN
      self.elementNumberInO = elementNumberInO
    }
  }
  
  @usableFromInline
  internal enum ElementOcurrence {
    case zero
    case one
    case two
    case many
    
    @inlinable
    internal mutating func increment() {
      switch self {
      case .zero: self = .one
      case .one:  self = .two
      case .two:  self = .many
      case .many: return
      }
    }
  }
    
  @usableFromInline
  internal enum Move: Equatable {
    case insert(Index)
    case delete(Index)
    case move(from: Index, to: Index)
    case update(Index)
  }
}
