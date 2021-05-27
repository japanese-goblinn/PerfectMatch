import PerfectMatchHeckellsDifference
import PerfectMatchTextEditor

public struct ContentView: View {
  @State var firstFileURL: String?
  @State private var firstTextToDiff: String = "kek"
  @State private var isTryingToDropFileOnFirstPane: Bool = false

  @State private var secondTextToDiff: String = "kek"
  @State private var isTryingToDropFileOnSecondPane: Bool = false
  
  @State private var isShowingDiffingResultView: Bool = false
  
  @Environment(\.colorScheme) private var theme
  
  @ViewBuilder
  private var content: some View {
    HStack(alignment: .center, spacing: 0) {
      VStack(spacing: 0) {
        if firstFileURL != nil {
          TabView(fileURL: $firstFileURL)
            .transition(.move(edge: .top))
        }
        ZStack {
          SourceCodeTextView(
            text: $firstTextToDiff,
            customization: .init(
              lexerForSource: { ShellLexer() }
            )
          )
          .id(theme == .light ? UUID() : UUID())
          DropView()
            .opacity(isTryingToDropFileOnFirstPane ? 0.95 : 0)
            .animation(.easeInOut(duration: 0.2))
        }
        .onDrop(
          of: [.fileURL],
          isTargeted: $isTryingToDropFileOnFirstPane
        ) { itemProviders in
          guard
            let file = itemProviders.first,
            let checkFile = itemProviders.last,
            file == checkFile
          else { return false }
          file.loadItem(
            forTypeIdentifier: kUTTypeURL as String,
            options: nil
          ) { data, error in
            if let error = error {
              return print(error.localizedDescription)
            }
            if let url = URL(dataRepresentation: data as! Data, relativeTo: nil) {
              withAnimation {
                firstFileURL = String(url.absoluteString.dropFirst("file://".count))
              }
            }
          }
          return true
        }
      }
    
      SourceCodeTextView(
        text: $secondTextToDiff,
        customization: .init(
          lexerForSource: { ShellLexer() }
        )
      )
      .id(UUID())
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        HStack {
          Button(action: {
            isShowingDiffingResultView.toggle()
          }) {
            Label(
              title: { Text("Show Difference") },
              icon: { Image(systemSymbol: .textAlignedLeft) }
            )
          }
        }
        .sheet(isPresented: $isShowingDiffingResultView) {
          DiffingResultView().frame(
            minWidth: 750,
            maxWidth: .infinity,
            minHeight: 600,
            maxHeight: .infinity
          )
        }
        .help("Show Difference")
      }
    }
    .keyboardShortcut(.defaultAction)
  }
  
  public var body: some View {
    content.frame(
      minWidth: 700,
      maxWidth: .infinity,
      minHeight: 600,
      maxHeight: .infinity
    )
  }
  
  public init() {}
}
