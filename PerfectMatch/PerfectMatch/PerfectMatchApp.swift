import PerfectMatchUI

@main
struct PerfectMatchApp: App {
  
  @NSApplicationDelegateAdaptor
  var appDelegate: AppDelegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(
          minWidth: 700,
          maxWidth: .infinity,
          minHeight: 600,
          maxHeight: .infinity
        )
    }
  }
}
