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
  
  @objc func handleEvent(_ event: NSAppleEventDescriptor, and replyEvent: NSAppleEventDescriptor) {
    #warning("WIP")
    guard
      let filesURLString = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue,
      let queryItems = URLComponents(string: filesURLString)?.queryItems
    else { return }
    for item in queryItems {
      print("\(item.name) : \(item.value)")
    }
  }
  
}
