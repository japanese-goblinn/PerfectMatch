import PerfectMatchUI

@main
struct PerfectMatchApp: App {
  
  @NSApplicationDelegateAdaptor
  var appDelegate: AppDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
