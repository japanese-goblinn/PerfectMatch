//
//  InnerTextView.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 09/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(macOS)
  import AppKit
#else
  import UIKit
#endif

protocol InnerTextViewDelegate: AnyObject {
  func didUpdateCursorFloatingState()
}

internal class InnerTextView: TextView {
  
  internal weak var innerDelegate: InnerTextViewDelegate?
  
  internal var theme: SyntaxColorTheme?
  
  internal var cachedParagraphs: [Paragraph]?
  
  internal func invalidateCachedParagraphs() {
    cachedParagraphs = nil
  }
  
  internal func hideGutter() {
    gutterWidth = theme?.gutterStyle.minimumWidth ?? 0.0
  }
  
  internal func updateGutterWidth(for numberOfCharacters: Int) {
    let leftInset: CGFloat = 4.0
    let rightInset: CGFloat = 4.0
    let charWidth: CGFloat = 10.0
    gutterWidth = max(
      theme?.gutterStyle.minimumWidth ?? 0.0,
      CGFloat(numberOfCharacters) * charWidth + leftInset + rightInset
    )
  }
  
  #if os(iOS)
    internal var isCursorFloating = false
    
    internal override func beginFloatingCursor(at point: CGPoint) {
      super.beginFloatingCursor(at: point)
      self.isCursorFloating = true
      self.innerDelegate?.didUpdateCursorFloatingState()
    }
    
    internal override func endFloatingCursor() {
      super.endFloatingCursor()
      self.isCursorFloating = false
      self.innerDelegate?.didUpdateCursorFloatingState()
    }
  
    internal override func draw(_ rect: CGRect) {
      guard let theme = theme else {
        super.draw(rect)
        return hideGutter()
      }
      
      let textView = self

      if theme.lineNumbersStyle == nil  {
        hideGutter()
        let gutterRect = CGRect(x: 0, y: rect.minY, width: textView.gutterWidth, height: rect.height)
        let path = BezierPath(rect: gutterRect)
        path.fill()
      } else {
        let components = textView.text.components(separatedBy: .newlines)
        let count = components.count
        let maxNumberOfDigits = "\(count)".count
        textView.updateGutterWidth(for: maxNumberOfDigits)
        
        var paragraphs: [Paragraph]
        if let cached = textView.cachedParagraphs {
          paragraphs = cached
        } else {
          paragraphs = generateParagraphs(for: textView, flipRects: false)
          textView.cachedParagraphs = paragraphs
        }
        
        theme.gutterStyle.backgroundColor.setFill()
        let gutterRect = CGRect(x: 0, y: rect.minY, width: textView.gutterWidth, height: rect.height)
        let path = BezierPath(rect: gutterRect)
        path.fill()
        drawLineNumbers(paragraphs, in: rect, for: self)
      }
    
      super.draw(rect)
    }
  #endif
  
  internal var gutterWidth: CGFloat {
    set {
      #if os(macOS)
        textContainerInset = NSSize(width: newValue, height: 0)
      #else
        textContainerInset = UIEdgeInsets(top: 0, left: newValue, bottom: 0, right: 0)
      #endif
      
    }
    get {
      #if os(macOS)
        return textContainerInset.width
      #else
        return textContainerInset.left
      #endif
    }
  }
  
  #if os(iOS)
    internal override func caretRect(for position: UITextPosition) -> CGRect {
      var superRect = super.caretRect(for: position)
      guard let theme = theme else {
        return superRect
      }
      let font = theme.font
      
      // "descender" is expressed as a negative value,
      // so to add its height you must subtract its value
      superRect.size.height = font.pointSize - font.descender
      return superRect
    }
  #endif
}
