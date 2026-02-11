#include <metal_stdlib>
using namespace metal;

struct RippleData {
    float2 position;
    float time;
    float amplitude;
};

[[stitchable]] half4 rippleEffect(
    float2 position,
    half4 color,
    device const RippleData *ripples,
    uint rippleCount,
    float2 size
) {
    float2 normalizedPos = position / size;
    float totalDisplacement = 0.0;
    
    for (uint i = 0; i < rippleCount; i++) {
        RippleData ripple = ripples[i];
        float2 ripplePos = ripple.position / size;
        float distance = length(normalizedPos - ripplePos);
        
        // Calculate wave propagation
        float waveSpeed = 2.0;
        float waveFrequency = 20.0;
        float decay = 1.0;
        
        float wave = ripple.time * waveSpeed;
        float distanceFromWave = abs(distance - wave);
        
        if (distanceFromWave < 0.1 && ripple.time < decay) {
            float strength = (1.0 - ripple.time / decay) * ripple.amplitude;
            strength *= exp(-distanceFromWave * 10.0);
            totalDisplacement += sin(distance * waveFrequency - ripple.time * 10.0) * strength;
        }
    }
    
    // Apply displacement to alpha/scale
    float scale = 1.0 + totalDisplacement * 0.5;
    scale = clamp(scale, 0.0, 2.0);
    
    return color * half(scale);
}
