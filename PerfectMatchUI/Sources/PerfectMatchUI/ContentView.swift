import PerfectMatchHeckellsDifference
import PerfectMatchResources
import PerfectMatchTextEditor

import PerfectMatchDependencies

//class

internal struct KeyPressHandlerView: NSViewRepresentable {
  internal var onKeyPressed: (_ event: NSEvent) -> Void
    
  internal func makeNSView(context: Context) -> NSView {
    let view = View()
    view.onKeyPressed = onKeyPressed
    DispatchQueue.main.async {
      view.window?.makeFirstResponder(view)
    }
    return view
  }
  
  internal func updateNSView(_ nsView: NSView, context: Context) {}
}

extension KeyPressHandlerView {
  private class View: NSView {
    internal var onKeyPressed: ((NSEvent) -> Void)!
    
    override var acceptsFirstResponder: Bool { true }
    
    override func keyDown(with event: NSEvent) {
      super.keyDown(with: event)
      self.onKeyPressed(event)
    }
  }
}

struct DiffingResultView: View {
  
  @Environment(\.presentationMode)
  private var presentationMode

  @State private var kek = "# kek"
  
  var body: some View {
    SourceCodeTextView(
      text: $kek,
      isEditable: false
    )
    .background(KeyPressHandlerView { event in
      guard
        event.keyCode == 76 || event.keyCode == 36
      else { return }
      presentationMode.wrappedValue.dismiss()
    })
  }
}

public struct ContentView: View {
//
//  @Environment(\.colorScheme)
//  private var colorScheme
//
  @State private var firstTextToDiff = "#!bin/bash"
  
  @State private var isShowingDiffingResultView = false
  
  @ViewBuilder
  private var content: some View {
    SourceCodeTextView(text: $firstTextToDiff)
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button(action: {
            isShowingDiffingResultView.toggle()
          }) {
            Label(
              title: { Text("Show Difference") },
              icon: { Image(systemSymbol: .textAlignedLeft) }
            )
          }
          .help("Show Difference")
        }
      }
      .sheet(isPresented: $isShowingDiffingResultView) {
        DiffingResultView().frame(
          minWidth: 800,
          maxWidth: .infinity,
          minHeight: 600,
          maxHeight: .infinity
        )
      }
//      .keyboardShortcut(.defaultAction)
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
