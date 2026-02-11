import SwiftUI

/// Example usage of the RippleEffect modifier.
struct ContentView: View {
    // Single ripple (tap replaces previous)
    @State private var rippleCounter = 0
    @State private var rippleOrigin: CGPoint = .zero

    // Multiple simultaneous ripples
    @State private var multipleRipples: [RippleState] = []
    @State private var multiRippleCounter = 0

    var body: some View {
        TabView {
            singleRippleExample
            multipleRipplesExample
            customParametersExample
        }
        .tabViewStyle(.sidebarAdaptable)
    }

    // MARK: - Single Ripple (tap to trigger)

    private var singleRippleExample: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.cyan.opacity(0.6), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Image(systemName: "drop.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(.white)
                    .shadow(radius: 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture(coordinateSpace: .local) { location in
                rippleOrigin = location
                rippleCounter += 1
            }
            .modifier(RippleEffectModifier(
                at: rippleOrigin,
                trigger: rippleCounter,
                amplitude: 12,
                frequency: 15,
                decay: 8,
                speed: 2000,
                duration: 3
            ))
            .navigationTitle("Single Ripple")
        }
    }

    // MARK: - Multiple Simultaneous Ripples

    private var multipleRipplesExample: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.mint.opacity(0.6), .blue.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                Text("Tap anywhere")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture(coordinateSpace: .local) { location in
                multiRippleCounter += 1
                let ripple = RippleState(origin: location, trigger: multiRippleCounter)
                multipleRipples.append(ripple)
                // Remove after animation completes
                Task {
                    try? await Task.sleep(for: .seconds(3.5))
                    await MainActor.run {
                        multipleRipples.removeAll { $0.id == ripple.id }
                    }
                }
            }
            .rippleEffect(
                ripples: $multipleRipples,
                amplitude: 12,
                frequency: 15,
                decay: 8,
                speed: 2000,
                duration: 3
            )
            .navigationTitle("Multiple Ripples")
        }
    }

    // MARK: - Custom Parameters

    private var customParametersExample: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.orange.opacity(0.6), .pink.opacity(0.6)],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
                .ignoresSafeArea()

                Image(systemName: "sparkles")
                    .font(.system(size: 100))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture(coordinateSpace: .local) { location in
                rippleOrigin = location
                rippleCounter += 1
            }
            .rippleEffect(
                at: rippleOrigin,
                trigger: rippleCounter,
                amplitude: 20,   // Taller waves
                frequency: 20,   // More waves
                decay: 5,        // Slower fade
                speed: 1500,     // Slower propagation
                duration: 4      // Longer animation
            )
            .navigationTitle("Custom Params")
        }
    }
}

#Preview {
    ContentView()
}
