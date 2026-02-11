/*
 RippleEffect.metal
 Metal shader for interactive ripple effect on SwiftUI views.
 */

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[stitchable]]
half4 RippleEffect(
    float2 position,
    SwiftUI::Layer layer,
    float2 origin,
    float time,
    float amplitude,
    float frequency,
    float decay,
    float speed
) {
    float distance = length(position - origin);
    float delay = distance / speed;
    float adjustedTime = max(0.0, time - delay);
    float rippleAmount = amplitude * sin(frequency * adjustedTime) * exp(-decay * adjustedTime);
    
    float2 delta = position - origin;
    float2 radialDir = distance > 0.0001 ? delta / distance : float2(0.0, 0.0);
    float2 newPosition = position + rippleAmount * radialDir;
    
    half4 color = layer.sample(newPosition);
    color.rgb += 0.3 * (rippleAmount / max(abs(amplitude), 0.0001)) * color.a;
    
    return color;
}
