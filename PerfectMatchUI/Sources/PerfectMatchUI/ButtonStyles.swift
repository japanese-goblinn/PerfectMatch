internal struct DestructiveButtonStyle: ButtonStyle {
  internal func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .font(.body.weight(.bold))
      .padding(10)
      .background(configuration.isPressed
                    ? Color.asset(.primaryRed).opacity(1.0)
                    : Color.asset(.primaryRed).opacity(0.92)
      )
      .cornerRadius(12)
      .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
      .animation(.easeOut)
  }
}

internal struct SmallRoundedDestructiveButtonStyle: ButtonStyle {
  internal func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(.white)
      .font(.body.weight(.bold))
      .padding(3)
      .background(configuration.isPressed
                    ? Color.asset(.primaryRed).opacity(1.0)
                    : Color.asset(.primaryRed).opacity(0.92)
      )
      .cornerRadius(20)
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
      .animation(.easeIn)
  }
}
