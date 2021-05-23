//
//  Paragraph.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 24/06/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(macOS)
  import AppKit
#else
  import UIKit
#endif

internal struct Paragraph {
  internal var rect: CGRect
  internal let number: Int
  
  internal var string: String { "\(number)" }
  
  internal func attributedString(for style: LineNumbersStyle) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: style.font,
      .foregroundColor : style.textColor
    ]
    attributedString.addAttributes(
      attributes,
      range: NSMakeRange(0, attributedString.length)
    )
    
    return attributedString
  }
  
  internal func drawSize(for style: LineNumbersStyle) -> CGSize {
    return attributedString(for: style).size()
  }
  
}

