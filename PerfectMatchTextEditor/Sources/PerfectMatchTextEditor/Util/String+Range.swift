//
//  String+Range.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 09/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation

internal extension String {
	func nsRange(fromRange range: Range<Index>) -> NSRange {
    return .init(range, in: self)
	}
}
