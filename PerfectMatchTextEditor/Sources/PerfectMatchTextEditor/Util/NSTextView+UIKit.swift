//
//  NSTextView+UIKit.swift
//  SavannaKit
//
//  Created by Louis D'hauwe on 09/07/2017.
//  Copyright © 2017 Silver Fox. All rights reserved.
//

#if os(macOS)
  import AppKit

  internal extension NSTextView {
    var text: String! {
      get { string }
      set { string = newValue }
    }
    
    var tintColor: Color {
      get { insertionPointColor }
      set { insertionPointColor = newValue }
    }
  }
#endif
