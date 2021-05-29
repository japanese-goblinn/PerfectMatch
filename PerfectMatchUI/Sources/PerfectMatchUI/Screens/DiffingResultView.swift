import PerfectMatchTextEditor

struct DiffingResultView: View {
  @Environment(\.presentationMode) private var presentationMode
  @Environment(\.colorScheme) private var theme
  
  @State private var kek: String = .mock()
  
  var body: some View {
    SourceCodeTextView(
      text: $kek,
      isEditable: false,
      customization: .init(
        lexerForSource: { ShellLexer() }
      ),
      linesHighlighter: { wrappedView in
        wrappedView.updateLineBackground(at: 0, with: .asset(.primaryRed, alpha: 0.5))
        wrappedView.updateLineBackground(at: 3, with: .asset(.primaryGreen, alpha: 0.5))
        wrappedView.updateLineBackground(at: 4, with: .asset(.primaryRed, alpha: 0.5))
        wrappedView.updateLineBackground(at: 6, with: .asset(.primaryRed, alpha: 0.5))
        wrappedView.updateLineBackground(at: 7, with: .asset(.primaryRed, alpha: 0.5))
        wrappedView.updateLineBackground(at: 8, with: .asset(.primaryRed, alpha: 0.5))
        wrappedView.updateLineBackground(at: 10, with: .asset(.primaryGreen, alpha: 0.5))
      }
    )
    .id(theme == .light ? UUID() : UUID())
    
    Button(action: {
      presentationMode.wrappedValue.dismiss()
    }) {
      Label(
        title: { Text("Close") },
        icon: { Image(systemSymbol: .xmarkSquare.filled()) }
      )
    }
    .buttonStyle(DestructiveButtonStyle())
    .padding(.bottom, 10)
  }
}
