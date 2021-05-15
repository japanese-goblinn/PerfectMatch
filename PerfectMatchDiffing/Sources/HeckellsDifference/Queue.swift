import Foundation
import Collections

@usableFromInline
internal struct Queue<T>: ExpressibleByArrayLiteral {
    @usableFromInline
    internal var _storage: Deque<T>
    
    @inlinable
    public mutating func push(_ item: T) {
        _storage.append(item)
    }
    
    @inlinable
    public mutating func pop() -> T? {
        return _storage.popFirst()
    }
    
    @inlinable
    public init(arrayLiteral elements: T...) {
        self = .init(elements)
    }
    
    @inlinable
    public init(_ items: [T]) {
        self._storage = .init(items)
    }
}
