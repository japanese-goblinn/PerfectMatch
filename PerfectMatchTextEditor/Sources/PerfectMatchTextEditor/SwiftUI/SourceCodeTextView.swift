//
//  SourceCodeTextEditor.swift
//
//  Created by Andrew Eades on 14/08/2020.
//

import Foundation
import SwiftUI

public struct SourceCodeTextView: NSViewRepresentable {
  
  @Binding private var text: String
  
  private var isEditable: Bool
  private var customisation: Customization
  private var linesHighlighter: ((SyntaxTextView) -> Void)? = nil
  
  public init(
    text: Binding<String>,
    isEditable: Bool = true,
    customization: Customization = .init(
      lexerForSource: { ShellLexer() }
    ),
    linesHighlighter: ((SyntaxTextView) -> Void)? = nil
  ) {
    self._text = text
    self.isEditable = isEditable
    self.customisation = customization
    self.linesHighlighter = linesHighlighter
  }
  
  public func makeCoordinator() -> Coordinator {
    return .init(self)
  }
  
  public func makeNSView(context: Context) -> SyntaxTextView {
    let wrappedView = SyntaxTextView()
    let coordinator = context.coordinator
    let environment = context.environment
    
    wrappedView.text = text
    wrappedView.textView.delegate = context.coordinator
    wrappedView.delegate = context.coordinator
    coordinator.representableView = wrappedView
    
    wrappedView.contentTextView.isEditable = isEditable
    wrappedView.theme =
      environment.colorScheme == .light ? LightTheme() : DarkTheme()
    wrappedView.contentTextView.insertionPointColor =
      environment.colorScheme == .light ? .black : .white
    wrappedView.scrollView.verticalScroller?.knobStyle =
      environment.colorScheme == .light ? .dark : .light

    linesHighlighter?(wrappedView)

    return wrappedView
  }
    
    public func updateNSView(_ view: SyntaxTextView, context: Context) {}
}

extension SourceCodeTextView {
  public class Coordinator: NSObject, SyntaxTextViewDelegate, NSTextViewDelegate {
    internal let swiftUIView: SourceCodeTextView
    internal var representableView: SyntaxTextView!
    
    init(_ swiftUIView: SourceCodeTextView) {
      self.swiftUIView = swiftUIView
    }
    
    public func lexerForSource(_ source: String) -> Lexer {
      swiftUIView.customisation.lexerForSource()
    }
    
    public func textDidChange(_ notification: Notification) {
      DispatchQueue.main.async {
        self.swiftUIView.text = self.representableView.text
      }
      swiftUIView.customisation.didChangeText?(swiftUIView)
    }
    
    
    public func textDidBeginEditing(_ notification: Notification) {
      swiftUIView.customisation.textViewDidBeginEditing?(swiftUIView)
    }
    
    #warning("Called only on delegate set")
    public func didChangeText(_ syntaxTextView: SyntaxTextView) {
//      DispatchQueue.main.async {
//        self.swiftUIView.text = syntaxTextView.text
//      }
//      swiftUIView.customisation.didChangeText?(swiftUIView)
    }
  }
}

extension SourceCodeTextView {
  public struct Customization {
    internal let lexerForSource: () -> Lexer
    internal let didChangeText: ((SourceCodeTextView) -> Void)?
    internal let textViewDidBeginEditing: ((SourceCodeTextView) -> Void)?
    
    public init(
      lexerForSource: @escaping () -> Lexer,
      didChangeText: ((SourceCodeTextView) -> Void)? = nil,
      textViewDidBeginEditing: ((SourceCodeTextView) -> Void)? = nil
    ) {
      self.lexerForSource = lexerForSource
      self.didChangeText = didChangeText
      self.textViewDidBeginEditing = textViewDidBeginEditing
    }
  }
}
