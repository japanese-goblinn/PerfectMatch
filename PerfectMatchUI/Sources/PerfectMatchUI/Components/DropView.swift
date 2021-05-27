internal struct DropView: View {
  internal var body: some View {
    ZStack {
      ViewRepresentable(NSVisualEffectView())
      VStack(spacing: 15) {
        Image(systemSymbol: .docText)
          .font(.system(size: 50))
        Text("Drop file to match")
          .bold()
      }
      .padding(70)
      .background(
        RoundedRectangle(cornerRadius: 25, style: .circular)
          .stroke(lineWidth: 2)
      )
    }
  }
}
