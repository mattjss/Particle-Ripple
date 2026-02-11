# Particle-Ripple

Experimenting with particle ripple effects.

An interactive, GPU-accelerated ripple effect for SwiftUI using Metal shaders. Tap or touch any view to create water-like ripples that propagate outward with configurable wave physics.

## Requirements

- iOS 17+
- Xcode 15+
- Swift 5.9+

## Setup

1. Create a new SwiftUI iOS App in Xcode (or add to existing project)
2. Add these files to your project:
   - `RippleEffect.metal` – Metal shader (ensure it’s in the app target)
   - `RippleModifier.swift` – View modifiers
   - `ContentView.swift` – Example usage (optional)
   - `ParticleRippleApp.swift` – App entry point (optional)

3. Make sure `RippleEffect.metal` is included in your app target’s **Compile Sources** and is compiled as part of the app.

## Usage

### Single ripple

```swift
@State private var rippleCounter = 0
@State private var rippleOrigin: CGPoint = .zero

MyView()
    .onTapGesture(coordinateSpace: .local) { location in
        rippleOrigin = location
        rippleCounter += 1
    }
    .rippleEffect(at: rippleOrigin, trigger: rippleCounter)
```

### Custom parameters

```swift
.rippleEffect(
    at: rippleOrigin,
    trigger: rippleCounter,
    amplitude: 12,   // Wave height (default: 12)
    frequency: 15,   // Number of waves (default: 15)
    decay: 8,        // Fade speed (default: 8)
    speed: 2000,     // Propagation velocity (default: 2000)
    duration: 3      // Animation length in seconds (default: 3)
)
```

### Multiple simultaneous ripples

```swift
@State private var ripples: [RippleState] = []
@State private var counter = 0

MyView()
    .onTapGesture(coordinateSpace: .local) { location in
        counter += 1
        ripples.append(RippleState(origin: location, trigger: counter))
        // Optional: remove after animation
        Task {
            try? await Task.sleep(for: .seconds(3.5))
            await MainActor.run { ripples.removeLast() }
        }
    }
    .rippleEffect(ripples: $ripples)
```

### With DragGesture (for press-and-drag)

```swift
.gesture(
    DragGesture(minimumDistance: 0)
        .onEnded { value in
            rippleOrigin = value.startLocation
            rippleCounter += 1
        }
)
.rippleEffect(at: rippleOrigin, trigger: rippleCounter)
```

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `amplitude` | 12 | Wave height (pixels) |
| `frequency` | 15 | Number of wave cycles |
| `decay` | 8 | Exponential fade rate |
| `speed` | 2000 | Propagation velocity (pixels/sec) |
| `duration` | 3 | Animation duration (seconds) |

## Architecture

- **RippleEffect.metal** – Metal shader using `sin(frequency * time) * exp(-decay * time)` for wave propagation
- **RippleModifier** – Applies the shader via `layerEffect()`
- **RippleEffectModifier** – Drives animation with `keyframeAnimator` and touch handling
- **MultipleRipplesModifier** – Stacks modifiers for multiple ripples

## License

MIT
