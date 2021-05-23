import PerfectMatchUI
import Combine

final class AppStore: ObservableObject {
  var subscribtion: Set<AnyCancellable> = .init()
  
  init() {}
}

@main
struct PerfectMatchApp: App {
  @NSApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  @StateObject var appStore = AppStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    Settings {
      SettingsView()
    }
  }
}
