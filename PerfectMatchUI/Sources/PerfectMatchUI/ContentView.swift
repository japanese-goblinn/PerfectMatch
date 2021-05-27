import PerfectMatchHeckellsDifference
import PerfectMatchResources
import PerfectMatchTextEditor

import PerfectMatchDependencies

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


struct DestructiveButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .font(.body.weight(.bold))
      .padding(10)
      .background(configuration.isPressed
                    ? Color.asset(.primaryRed).opacity(1.0)
                    : Color.asset(.primaryRed).opacity(0.92)
      )
      .cornerRadius(12)
      .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
      .animation(.easeOut)
  }
}
 
struct DiffingResultView: View {
  @Environment(\.presentationMode) private var presentationMode
  
  @State private var kek: String = .mock()
  
  var body: some View {
    SourceCodeTextView(
      text: $kek,
      isEditable: false,
      customization: .init(
        lexerForSource: { ShellLexer() }
      )
    )
    .id(UUID())
    
    Button(action: {
      presentationMode.wrappedValue.dismiss()
    }) {
      Label(
        title: { Text("Close") },
        icon: { Image(systemSymbol: .xmarkSquareFill) }
      )
    }
    .buttonStyle(DestructiveButtonStyle())
    .padding(.bottom, 10)
  }
}

struct ViewRepresentable<WrappedView: NSView>: NSViewRepresentable {
  private let wrappedView: () -> WrappedView
  private let updater: ((WrappedView, Context) -> Void)?
  private let coordinatorMaker: (() -> Coordinator)? = nil
  
  init(
    _ wrappedView: @autoclosure @escaping () -> WrappedView,
    updater: ((WrappedView, Context) -> Void)? = nil
  ) {
    self.wrappedView = wrappedView
    self.updater = updater
  }

  func makeNSView(context: Context) -> WrappedView {
    return wrappedView()
  }
  
  func updateNSView(_ nsView: WrappedView, context: Context) {
    updater?(nsView, context)
  }
}


struct DropView: View {
  var body: some View {
    ZStack {
      ViewRepresentable(NSVisualEffectView())
      VStack(spacing: 15) {
        Image(systemSymbol: .doc)
          .font(.system(size: 50))
        Text("Drop file to diff here")
          .font(.title3.bold())
      }
      .padding(70)
      .background(
        RoundedRectangle(cornerRadius: 25, style: .circular)
          .stroke(lineWidth: 2)
      )
    }
  }
}

struct TabView: View {
  @Binding var fileURL: String?
  
  var body: some View {
    Label(
      title: { Text(fileURL ?? "No file") },
      icon: {
        Image(nsImage: NSWorkspace.shared.icon(forFile: fileURL ?? ""))
          .resizable()
          .frame(width: 20, height: 20)
      }
    )
  }
}

public struct ContentView: View {
  @State var firstFileURL: String?
  @State private var firstTextToDiff: String = "kek"
  @State private var isTryingToDropFileOnFirstPane: Bool = false

  @State private var secondTextToDiff: String = "kek"
  @State private var isTryingToDropFileOnSecondPane: Bool = false
  
  @State private var isShowingDiffingResultView: Bool = false
  
  @ViewBuilder
  private var content: some View {
    HStack(alignment: .center, spacing: 0) {
      VStack {
        TabView(fileURL: $firstFileURL)
        
        ZStack {
          SourceCodeTextView(
            text: $firstTextToDiff,
            customization: .init(
              lexerForSource: { ShellLexer() }
            )
          )
          .id(UUID())

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
              print(url.absoluteString)
              firstFileURL = String(url.absoluteString.dropFirst("file://".count))
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

extension String {
  static func mock() -> Self {
    """
    #!/bin/bash

    # Usage
    # rename_assets path/to/Assets.xcassets (just rename_assets will use default path)

    # In current implementation do not updates `Contents.json` file :c

    # Possible problems:
    # assets is processing in order that they presented in directory and do not compared by size
    # so if asset, asset@2x, asset@3x is presetned in directory they should be placed in right order

    set -e

    GREEN="\033[32m"
    PURPLE="\033[95m"
    RED="\033[31m"
    COLOR_RESET="\033[0m"

    BASE_DIR=${1-"./EduDoResources/Sources/EduDoResources/Resources/Assets.xcassets/"}
    EXT_TO_BE_RENAMED=("png" "svg" "pdf")

    rename_file() {
        if [[ ! -f $1 ]]; then return 1; fi
        local dir=$(dirname "$1")
        if [[ "${dir##*.}" != "imageset" ]]; then return 1; fi
        local ext="${1##*.}"
        if [[ ! "${EXT_TO_BE_RENAMED[@]}" =~ $ext ]]; then return 1; fi

        local dir=$(dirname "$1")
        local ext="${1##*.}"
        local file_to_rename="$1"
        local rename_to=$(basename "${dir%.*}")
        local dir_full="$dir"
        local asset_count="$2"
        (( asset_count += 1 ))
       
        if [[ "$asset_count" == 1 ]]; then
            mv "$file_to_rename" "${dir_full}/${rename_to}.${ext}"
        else
            mv "$file_to_rename" "${dir_full}/${rename_to}@${asset_count}x.${ext}"
        fi
    }

    traverse_files_from_dir() {
        local asset_count=0
        for i in "$1"/*; do
            if [[ ! -d "$i" ]]; then
                rename_file "$i" "$asset_count"
                local is_rename_succeeded=$?
                if [[ "$is_rename_succeeded" != 0 ]]; then continue; fi
                (( asset_count += 1 ))
            else
                traverse_files_from_dir "$i"
            fi
        done
    }

    if [[ $(basename "$BASE_DIR") != "Assets.xcassets" ]]; then
        echo -e "${RED}🛑 ERROR:${COLOR_RESET} Not an '*.xcassets' directory"
        exit
    fi

    echo -e "${PURPLE}🚀 Processing...${COLOR_RESET}"
    traverse_files_from_dir "$BASE_DIR" && echo -e "${GREEN}✅ DONE${COLOR_RESET}"

    """
  }
}
