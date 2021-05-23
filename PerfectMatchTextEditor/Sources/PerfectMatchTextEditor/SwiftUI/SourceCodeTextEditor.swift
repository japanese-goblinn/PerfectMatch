//
//  SourceCodeTextEditor.swift
//
//  Created by Andrew Eades on 14/08/2020.
//

import Foundation

#if canImport(SwiftUI)
  import SwiftUI
#if os(macOS)
  public typealias _ViewRepresentable = NSViewRepresentable
#endif

#if os(iOS)
  public typealias _ViewRepresentable = UIViewRepresentable
#endif


public struct SourceCodeTextEditor: _ViewRepresentable {
  
  @Binding private var text: String
  
  private var shouldBecomeFirstResponder: Bool
  private var custom: Customization
  
  public init(
    text: Binding<String>,
    customization: Customization = .init(
      didChangeText: {_ in },
      insertionPointColor: { .white },
      lexerForSource: { _ in ShellLexer() },
      textViewDidBeginEditing: { _ in },
      theme: { DefaultSourceCodeTheme() }
    ),
    shouldBecomeFirstResponder: Bool = false
  ) {
    self._text = text
    self.custom = customization
    self.shouldBecomeFirstResponder = shouldBecomeFirstResponder
  }
  
  public func makeCoordinator() -> Coordinator {
    return .init(self)
  }
  
  #if os(iOS)
    public func makeUIView(context: Context) -> SyntaxTextView {
      let wrappedView = SyntaxTextView()
      wrappedView.delegate = context.coordinator
      wrappedView.theme = custom.theme()
      
      context.coordinator.wrappedView = wrappedView
      context.coordinator.wrappedView.text = text
      
      return wrappedView
    }
    
    public func updateUIView(_ view: SyntaxTextView, context: Context) {
      guard shouldBecomeFirstResponder else { return }
      view.becomeFirstResponder()
    }
  #endif
  
  #if os(macOS)
    public func makeNSView(context: Context) -> SyntaxTextView {
      let wrappedView = SyntaxTextView()
      wrappedView.delegate = context.coordinator
      wrappedView.theme = custom.theme()
      wrappedView.contentTextView.insertionPointColor = custom.insertionPointColor()
      
      context.coordinator.wrappedView = wrappedView
      context.coordinator.wrappedView.text = text
      
      return wrappedView
    }
    
    public func updateNSView(_ view: SyntaxTextView, context: Context) {}
  #endif
}

extension SourceCodeTextEditor {
  public class Coordinator: SyntaxTextViewDelegate {
    internal let parent: SourceCodeTextEditor
    internal var wrappedView: SyntaxTextView!
    
    init(_ parent: SourceCodeTextEditor) {
      self.parent = parent
    }
    
    public func lexerForSource(_ source: String) -> Lexer {
      parent.custom.lexerForSource(source)
    }
    
    public func didChangeText(_ syntaxTextView: SyntaxTextView) {
      DispatchQueue.main.async {
        self.parent.text = syntaxTextView.text
      }
      // allow the client to decide on thread
      parent.custom.didChangeText(parent)
    }
    
    public func textViewDidBeginEditing(_ syntaxTextView: SyntaxTextView) {
      parent.custom.textViewDidBeginEditing(parent)
    }
  }
}
#endif

extension SourceCodeTextEditor {
  public struct Customization {
    internal var didChangeText: (SourceCodeTextEditor) -> Void
    internal var insertionPointColor: () -> Color
    internal var lexerForSource: (String) -> Lexer
    internal var textViewDidBeginEditing: (SourceCodeTextEditor) -> Void
    internal var theme: () -> SourceCodeTheme
    
    /// Creates a **Customization** to pass into the *init()* of a **SourceCodeTextEditor**.
    ///
    /// - Parameters:
    ///     - didChangeText: A SyntaxTextView delegate action.
    ///     - lexerForSource: The lexer to use (default: SwiftLexer()).
    ///     - insertionPointColor: To customize color of insertion point caret (default: .white).
    ///     - textViewDidBeginEditing: A SyntaxTextView delegate action.
    ///     - theme: Custom theme (default: DefaultSourceCodeTheme()).
    public init(
      didChangeText: @escaping (SourceCodeTextEditor) -> Void,
      insertionPointColor: @escaping () -> Color,
      lexerForSource: @escaping (String) -> Lexer,
      textViewDidBeginEditing: @escaping (SourceCodeTextEditor) -> Void,
      theme: @escaping () -> SourceCodeTheme
    ) {
      self.didChangeText = didChangeText
      self.insertionPointColor = insertionPointColor
      self.lexerForSource = lexerForSource
      self.textViewDidBeginEditing = textViewDidBeginEditing
      self.theme = theme
    }
  }
}
