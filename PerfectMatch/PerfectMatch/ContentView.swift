import SwiftUI

struct ContentView: View {
  var body: some View {
    Text("Hello, world!")
      .frame(
        minWidth: 700,
        maxWidth: .infinity,
        minHeight: 600,
        maxHeight: .infinity
      )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
