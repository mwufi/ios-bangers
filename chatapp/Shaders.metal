//
//  Shaders.metal
//  chatapp
//
//  Created by Zen on 12/22/24.
//

#include <metal_stdlib>
using namespace metal;


[[ stitchable ]] half4
angledFill(float2 position, float width, float angle, half4 color, float time)
{
    float pMagnitude = sqrt(position.x * position.x + position.y * position.y);
    float pAngle = angle + sin(time) * M_PI_F / 4.0f +
        (position.x == 0.0f ? (M_PI_F / 2.0f) : atan(position.y / position.x));
    float rotatedX = pMagnitude * cos(pAngle);
    float rotatedY = pMagnitude * sin(pAngle);
    float animatedWidth = width * (1.0f + 0.5f * sin(time));
    return (color + color * fmod(abs(rotatedX + rotatedY), animatedWidth) / animatedWidth) / 2;
}

[[ stitchable ]] half4 meshGradient(float2 pos, float time) {
    float2 center = float2(0.5);
    float2 toCenter = pos - center;
    
    // Create multiple noise waves
    float noise1 = sin(dot(pos, float2(cos(time), sin(time))) * 4.0 + time);
    float noise2 = cos(dot(pos, float2(-sin(time), cos(time * 0.5))) * 3.0 + time * 0.7);
    float noise3 = sin(length(toCenter) * 5.0 - time);
    
    // Combine noises with different frequencies
    float finalNoise = (noise1 + noise2 + noise3) / 3.0;
    
    // Create color gradients
    half4 color1 = half4(0.4, 0.2, 0.9, 1.0); // Purple
    half4 color2 = half4(0.1, 0.4, 0.8, 1.0); // Blue
    half4 color3 = half4(0.2, 0.8, 0.7, 1.0); // Turquoise
    
    // Mix colors based on noise and position
    half4 finalColor = mix(mix(color1, color2, finalNoise), color3, length(toCenter));
    
    return finalColor;
}
