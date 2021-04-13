import XCTest

import PerfectMatchDiffingTests

var tests = [XCTestCaseEntry]()
tests += DiffingTests.allTests()
XCTMain(tests)
