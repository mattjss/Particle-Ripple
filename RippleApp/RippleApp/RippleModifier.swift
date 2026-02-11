import SwiftUI

struct RippleModifier: ViewModifier {
    let origin: CGPoint
    let elapsedTime: TimeInterval
    let duration: TimeInterval
    let amplitude: Double
    let frequency: Double
    let decay: Double
    let speed: Double

    func body(content: Content) -> some View {
        let shader = ShaderLibrary.RippleEffect(
            .float2(origin),
            .float(elapsedTime),
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )
        let isEnabled = elapsedTime > 0 && elapsedTime < duration
        let offset = CGSize(width: abs(amplitude), height: abs(amplitude))

        content
            .visualEffect { view, _ in
                view.layerEffect(
                    shader,
                    maxSampleOffset: offset,
                    isEnabled: isEnabled
                )
            }
    }
}

struct RippleEffectModifier<T: Equatable>: ViewModifier {
    let origin: CGPoint
    let trigger: T
    let amplitude: Double
    let frequency: Double
    let decay: Double
    let speed: Double
    let duration: TimeInterval

    init(
        at origin: CGPoint,
        trigger: T,
        amplitude: Double = 12,
        frequency: Double = 15,
        decay: Double = 8,
        speed: Double = 2000,
        duration: TimeInterval = 3
    ) {
        self.origin = origin
        self.trigger = trigger
        self.amplitude = amplitude
        self.frequency = frequency
        self.decay = decay
        self.speed = speed
        self.duration = duration
    }

    func body(content: Content) -> some View {
        content
            .keyframeAnimator(
                initialValue: 0.0,
                trigger: trigger
            ) { view, elapsedTime in
                view.modifier(RippleModifier(
                    origin: origin,
                    elapsedTime: elapsedTime,
                    duration: duration,
                    amplitude: amplitude,
                    frequency: frequency,
                    decay: decay,
                    speed: speed
                ))
            } keyframes: { _ in
                MoveKeyframe(0)
                LinearKeyframe(duration, duration: duration)
            }
    }
}

struct RippleState: Identifiable {
    let id = UUID()
    let origin: CGPoint
    let trigger: Int
}

struct MultipleRipplesModifier: ViewModifier {
    @Binding var ripples: [RippleState]
    let amplitude: Double
    let frequency: Double
    let decay: Double
    let speed: Double
    let duration: TimeInterval

    func body(content: Content) -> some View {
        var result = AnyView(content)
        for ripple in ripples {
            result = AnyView(
                result.modifier(RippleEffectModifier(
                    at: ripple.origin,
                    trigger: ripple.trigger,
                    amplitude: amplitude,
                    frequency: frequency,
                    decay: decay,
                    speed: speed,
                    duration: duration
                ))
            )
        }
        return result
    }
}

extension View {
    func rippleEffect<T: Equatable>(
        at origin: CGPoint,
        trigger: T,
        amplitude: Double = 12,
        frequency: Double = 15,
        decay: Double = 8,
        speed: Double = 2000,
        duration: TimeInterval = 3
    ) -> some View {
        modifier(RippleEffectModifier(
            at: origin,
            trigger: trigger,
            amplitude: amplitude,
            frequency: frequency,
            decay: decay,
            speed: speed,
            duration: duration
        ))
    }

    func rippleEffect(
        ripples: Binding<[RippleState]>,
        amplitude: Double = 12,
        frequency: Double = 15,
        decay: Double = 8,
        speed: Double = 2000,
        duration: TimeInterval = 3
    ) -> some View {
        modifier(MultipleRipplesModifier(
            ripples: ripples,
            amplitude: amplitude,
            frequency: frequency,
            decay: decay,
            speed: speed,
            duration: duration
        ))
    }
}
