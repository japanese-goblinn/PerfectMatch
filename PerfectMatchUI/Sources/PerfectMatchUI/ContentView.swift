import PerfectMatchHeckellsDifference
import PerfectMatchResources

import PerfectMatchDependencies_Sourceful

public struct ContentView: View {
  
  @State private var string = "let a = 4"
  
  public var body: some View {
    SourceCodeTextEditor(text: $string)
      .toolbar {
        ToolbarItemGroup {
          Image(systemSymbol: .gearshapeFill)
        }
      }
  }
  
  public init() {}
}
