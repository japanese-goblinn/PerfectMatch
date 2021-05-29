@_exported import SwiftUI
@_exported import AppKit
@_exported import Foundation
@_exported import PerfectMatchResources

#warning("Need a maper from kUTTypeURL to UTType")
internal extension NSItemProvider {
  func loadURL(
    onLoad: @escaping (Result<URL, Error>) -> Void
  ) {
    loadItem(
      forTypeIdentifier: kUTTypeURL as String,
      options: nil
    ) { data, error in
      if let error = error {
        return onLoad(.failure(error))
      }
      if let url = URL(dataRepresentation: data as! Data, relativeTo: nil) {
        return onLoad(.success(url))
      }
    }
  }
}

internal extension Substring {
  var lastPathComponent: String { (self as NSString).lastPathComponent }
}

internal struct ViewRepresentable<WrappedView: NSView>: NSViewRepresentable {
  private let wrappedView: () -> WrappedView
  private let updater: ((WrappedView, Context) -> Void)?
  private let coordinatorMaker: (() -> Coordinator)? = nil
  
  internal init(
    _ wrappedView: @autoclosure @escaping () -> WrappedView,
    updater: ((WrappedView, Context) -> Void)? = nil
  ) {
    self.wrappedView = wrappedView
    self.updater = updater
  }

  internal func makeNSView(context: Context) -> WrappedView {
    return wrappedView()
  }
  
  internal func updateNSView(_ nsView: WrappedView, context: Context) {
    updater?(nsView, context)
  }
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

//internal struct KeyPressHandlerView: NSViewRepresentable {
//  internal var onKeyPressed: (_ event: NSEvent) -> Void
//    
//  internal func makeNSView(context: Context) -> NSView {
//    let view = View()
//    view.onKeyPressed = onKeyPressed
//    DispatchQueue.main.async {
//      view.window?.makeFirstResponder(view)
//    }
//    return view
//  }
//  
//  internal func updateNSView(_ nsView: NSView, context: Context) {}
//}
//
//extension KeyPressHandlerView {
//  private class View: NSView {
//    internal var onKeyPressed: ((NSEvent) -> Void)!
//    
//    override var acceptsFirstResponder: Bool { true }
//    
//    override func keyDown(with event: NSEvent) {
//      super.keyDown(with: event)
//      self.onKeyPressed(event)
//    }
//  }
//}
