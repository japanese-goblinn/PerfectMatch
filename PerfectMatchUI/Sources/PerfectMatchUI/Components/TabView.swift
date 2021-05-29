import PerfectMatchResources

internal struct TabView: View {
  @Binding internal var fileURL: String?
  
  internal var onClose: (() -> Void)? = nil

//  @StateObject private var viewModel: ViewModel = .init(fileURL: nil)
  
  internal var body: some View {
    HStack {
      Image(nsImage: NSWorkspace.shared.icon(forFile: fileURL ?? ""))
        .resizable()
        .frame(width: 20, height: 20)
      Text(fileURL.map { ($0 as NSString).lastPathComponent } ?? "")
        .bold()
      Spacer()
      Button(action: {
        withAnimation {
          onClose?()
          fileURL = nil
        }
      }) {
        Image(systemSymbol: .xmark)
      }
      .buttonStyle(SmallRoundedDestructiveButtonStyle())
      .padding(.trailing, 13)
    }
    .padding(5)
  }
}

//extension TabView {
//  internal final class ViewModel: ObservableObject {
//    @Published internal var fileURL: String?
//
//    var fileName: String {
//      fileURL.map { ($0 as NSString).lastPathComponent } ?? ""
//    }
//
//    internal func fetchImage() -> NSImage {
//      return NSWorkspace.shared.icon(forFile: fileURL ?? "")
//    }
//
//    internal func removeURL() {
//      fileURL = nil
//    }
//
//    init(fileURL: String?) {
//      self.fileURL = fileURL
//    }
//  }
//}
