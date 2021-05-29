import PerfectMatchHeckellsDifference

public struct ContentView: View {
  @State private var firstFileURL: String?
  @State private var isFirstPaneTextViewInFocus: Bool = true
  @State private var firstTextToDiff: String = ""
  @State private var isTryingToDropFileOnFirstPane: Bool = false

  @State private var secondFileURL: String?
  @State private var isSecondPaneTextViewInFocus: Bool = true
  @State private var secondTextToDiff: String = ""
  @State private var isTryingToDropFileOnSecondPane: Bool = false
  
  @State private var isShowingDiffingResultView: Bool = false
  
  @ViewBuilder
  private var content: some View {
    HStack(spacing: 0) {
      PaneView(
        textToShow: $firstTextToDiff,
        fileURL: $firstFileURL,
        isInFocus: $isFirstPaneTextViewInFocus,
        isTryingToDropFile: $isTryingToDropFileOnFirstPane
      )
      Divider()
      PaneView(
        textToShow: $secondTextToDiff,
        fileURL: $secondFileURL,
        isInFocus: $isSecondPaneTextViewInFocus,
        isTryingToDropFile: $isTryingToDropFileOnSecondPane
      )
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: {
          isShowingDiffingResultView.toggle()
        }) {
          Image(systemSymbol: .textAlignedLeft)
        }
        .sheet(isPresented: $isShowingDiffingResultView) {
          DiffingResultView()
            .frame(
              minWidth: 750,
              maxWidth: .infinity,
              minHeight: 600,
              maxHeight: .infinity
            )
        }
        .help("Find Perfect Match")
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
