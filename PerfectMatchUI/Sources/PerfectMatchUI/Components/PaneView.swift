import PerfectMatchResources
import PerfectMatchTextEditor

fileprivate extension PaneView {
  struct OutaFocusView: View {
    var body: some View {
      Rectangle()
        .background(Color.black)
        .opacity(0.3)
    }
  }
}

internal struct PaneView: View {
  @Environment(\.colorScheme) private var theme
  
  @Binding internal var textToShow: String
  @Binding internal var fileURL: String?
  @Binding internal var isInFocus: Bool
  @Binding internal var isTryingToDropFile: Bool
  
  @State private var isShowingError: Bool = false
  
  internal var body: some View {
    VStack(spacing: 0) {
      if fileURL != nil {
        TabView(fileURL: $fileURL) {
          withAnimation { isInFocus = true }
        }
        .transition(.move(edge: .top))
        .opacity(isInFocus ? 0.3 : 1.0)
        .contentShape(Rectangle()) // spacer now clickable
        .onTapGesture {
          withAnimation { isInFocus = false }
        }
      }
      ZStack {
        SourceCodeTextView(
          text: $textToShow,
          customization: .init(
            lexerForSource: { ShellLexer() }
          )
        )
        .id(theme == .light ? UUID() : UUID())
      
        if !isInFocus  {
          OutaFocusView()
            .onTapGesture {
              withAnimation { isInFocus = true }
            }
        }
        
        DropView()
          .opacity(isTryingToDropFile ? 0.95 : 0)
          .animation(.easeInOut(duration: 0.2))
      }
      .alert(isPresented: $isShowingError) {
        Alert(
          title: Text("Error"),
          dismissButton: .default(Text("OK"))
        )
      }
      .onDrop(of: [.fileURL], isTargeted: $isTryingToDropFile) { itemProviders in
        guard
          let fileProvider = itemProviders.first,
          let checkFileProvider = itemProviders.last,
          fileProvider == checkFileProvider
        else {
          isShowingError = true
          return false
        }
        fileProvider.loadURL { result in
          switch result {
          case .success(let url):
            withAnimation {
              isInFocus = false
              fileURL = String(url.absoluteString.dropFirst("file://".count))
            }
          case .failure:
            isShowingError = true
          }
        }
        return true
      }
    }
  }
}
