import XCTest
@testable import PerfectMatchHeckellsDifference

internal final class PerfectMatchDiffingTests: XCTestCase {
  
  internal func testHeckellsDifferenceElementOcurrence() {
    var entry: HeckellsDifference<Array<Int>>.ElementOcurrence = .zero
    entry.increment()
    XCTAssertEqual(entry, .one)
    entry.increment()
    XCTAssertEqual(entry, .two)
    entry.increment()
    XCTAssertEqual(entry, .many)
    entry.increment()
    XCTAssertEqual(entry, .many)
  }
    
  internal func testHeckellsDifference() {
    let diff1 = HeckellsDifference(
      of: "🤡😎",
      and: "😎🤡"
    )
    XCTAssertEqual(diff1.moves.count, 2)
    
    let diff2 = HeckellsDifference(
      of: [0, 1, 2, 3, 4, 5, 6, 7, 8],
      and: [0, 2, 3, 4, 7, 6, 9, 5, 10]
    )
    XCTAssertEqual(diff2.moves.count, 6)
    let diff3 = HeckellsDifference(
      of: [1, 2, 3, 3, 4],
      and: [2, 3, 1, 3, 4]
    )
    XCTAssertEqual(diff3.moves.count, 4)
    let diff4 = HeckellsDifference(
      of: "ABAC",
      and: "BA"
    )
    XCTAssertEqual(diff4.moves.count, 4)
    
    let diff5 = HeckellsDifference(
      of: "The men are bad. I hate the men",
      and: "The men are bad. John likes the men. I hate the men"
    )
    XCTAssertEqual(diff5.moves.count, "John likes the men. ".count)
    
    let diff6 = HeckellsDifference(of: "", and: "ABCD")
    XCTAssertEqual(diff6.moves.count, 4)
    
    let diff7 = HeckellsDifference(of: "ABCD", and: "")
    XCTAssertEqual(diff7.moves.count, 4)
    
    let diff8 = HeckellsDifference(of: "", and: "")
    XCTAssertTrue(diff8.moves.isEmpty)
  }

  internal func testCollectionDiffer() {
    let s1 = "ABCABC"
    let s2 = "ACABCB"
    let diff1 = s1.differ(from: s2)
    let diff2 = HeckellsDifference(of: s1, and: s2)
    XCTAssertEqual(diff1.moves, diff2.moves)
  }
  
  /// current baseline: 0.101 s
  internal func testPerformance() {
    let s1 = String(repeating: "OABC", count: 10000).shuffled()
    let s2 = String(repeating: "OABC", count: 10000).shuffled()
    measure {
      _ = HeckellsDifference(of: s1, and: s2)
    }
  }
  
}
