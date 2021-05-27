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
      )
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
