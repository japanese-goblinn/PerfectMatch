import PerfectMatchUI
import Combine

@main
struct PerfectMatchApp: App {
  @NSApplicationDelegateAdaptor var appDelegate: AppDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    Settings {
      SettingsView()
    }
  }
}
