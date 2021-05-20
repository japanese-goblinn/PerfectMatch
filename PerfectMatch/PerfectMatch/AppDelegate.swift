import PerfectMatchUI

final class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ notification: Notification) {
    #warning("WIP")
    NSAppleEventManager.shared().setEventHandler(
      self,
      andSelector: #selector(handleEvent(_:and:)),
      forEventClass: AEEventClass(kInternetEventClass),
      andEventID: AEEventID(kAEGetURL)
    )
  }
  
  @objc private func handleEvent(
    _ event: NSAppleEventDescriptor,
    and replyEvent: NSAppleEventDescriptor
  ) {
    #warning("WIP")
    guard
      let urlSchemeString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
      let url = URL(string: urlSchemeString),
      url.absoluteString.hasPrefix("perfectmatch"),
      url.host == "fileHandling",
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems
    else { return }
    for item in queryItems {
      print("\(item.name) : \(item.value)")
    }
  }
  
}
