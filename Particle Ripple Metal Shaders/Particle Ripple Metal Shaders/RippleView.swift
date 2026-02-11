import SwiftUI

struct RippleData {
    var position: SIMD2<Float>
    var time: Float
    var amplitude: Float
    
    init(position: CGPoint, time: Float = 0, amplitude: Float = 1.0) {
        self.position = SIMD2<Float>(Float(position.x), Float(position.y))
        self.time = time
        self.amplitude = amplitude
    }
}

struct RippleView: View {
    @State private var ripples: [RippleData] = []
    @State private var currentTime: Date = Date()
    
    let columns = 20
    let rows = 40
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                Canvas { context, size in
                    let dotSpacing = size.width / CGFloat(columns)
                    
                    for row in 0..<rows {
                        for col in 0..<columns {
                            let x = CGFloat(col) * dotSpacing + dotSpacing / 2
                            let y = CGFloat(row) * dotSpacing + dotSpacing / 2
                            let dotPosition = CGPoint(x: x, y: y)
                            
                            // Calculate displacement from all ripples
                            var scale: CGFloat = 1.0
                            
                            for ripple in ripples {
                                let ripplePoint = CGPoint(x: CGFloat(ripple.position.x),
                                                        y: CGFloat(ripple.position.y))
                                let distance = hypot(dotPosition.x - ripplePoint.x,
                                                   dotPosition.y - ripplePoint.y)
                                
                                let waveSpeed: CGFloat = 200.0
                                let waveFrequency: CGFloat = 0.05
                                let decay: CGFloat = 1.5
                                
                                let wave = CGFloat(ripple.time) * waveSpeed
                                let distanceFromWave = abs(distance - wave)
                                
                                if distanceFromWave < 50 && CGFloat(ripple.time) < decay {
                                    let strength = (1.0 - CGFloat(ripple.time) / decay) * CGFloat(ripple.amplitude)
                                    let falloff = exp(-distanceFromWave / 20.0)
                                    let displacement = sin(distance * waveFrequency - CGFloat(ripple.time) * 10.0) * strength * falloff
                                    scale += displacement * 0.8
                                }
                            }
                            
                            scale = max(0.1, min(scale, 2.0))
                            
                            let dotSize = 3.0 * scale
                            let rect = CGRect(x: x - dotSize / 2,
                                            y: y - dotSize / 2,
                                            width: dotSize,
                                            height: dotSize)
                            
                            let opacity = scale > 0.3 ? 1.0 : 0.3
                            context.fill(
                                Circle().path(in: rect),
                                with: .color(.white.opacity(opacity))
                            )
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            addRipple(at: value.location)
                        }
                )
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func addRipple(at position: CGPoint) {
        let newRipple = RippleData(position: position, time: 0, amplitude: 1.0)
        ripples.append(newRipple)
        
        // Limit number of active ripples
        if ripples.count > 5 {
            ripples.removeFirst()
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            let deltaTime: Float = 1.0 / 60.0
            DispatchQueue.main.async {
                var updated = ripples
                for i in updated.indices {
                    updated[i].time += deltaTime
                }
                updated.removeAll { $0.time > 1.5 }
                ripples = updated
                currentTime = Date()
            }
        }
    }
}
