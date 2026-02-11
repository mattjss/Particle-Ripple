/*
 RippleEffect.metal
 A Metal shader that applies an interactive ripple effect to SwiftUI views.
 Uses wave propagation: sin(frequency * time) * exp(-decay * time)
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
    // Distance from touch origin to current pixel
    float distance = length(position - origin);
    
    // Time delay for wave propagation (ripple travels outward at `speed`)
    float delay = distance / speed;
    float adjustedTime = max(0.0, time - delay);
    
    // Wave propagation: sine wave with exponential decay
    // amplitude * sin(frequency * time) * exp(-decay * time)
    float rippleAmount = amplitude * sin(frequency * adjustedTime) * exp(-decay * adjustedTime);
    
    // Radial direction from origin (normalized); avoid NaN at origin
    float2 delta = position - origin;
    float2 radialDir = distance > 0.0001 ? delta / distance : float2(0.0, 0.0);
    
    // Displace sampling position radially based on wave amplitude
    float2 newPosition = position + rippleAmount * radialDir;
    
    // Sample the layer at the displaced position
    half4 color = layer.sample(newPosition);
    
    // Adjust brightness based on wave amplitude (subtle highlight/depth)
    color.rgb += 0.3 * (rippleAmount / max(abs(amplitude), 0.0001)) * color.a;
    
    return color;
}
