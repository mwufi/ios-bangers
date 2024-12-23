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
