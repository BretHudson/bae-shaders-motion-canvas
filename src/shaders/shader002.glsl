#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

vec3 palette(in float t)
{
    vec3 a = vec3(0.731, 1.098, 0.192);
    vec3 b = vec3(0.358, 1.090, 0.657);
    vec3 c = vec3(1.077, 0.360, 0.328);
    vec3 d = vec3(0.965, 2.265, 0.837);
    return a + b * cos(6.28318 * (c * t + d));
}

uniform float iTime;

// kudos to @kishimisu https://www.youtube.com/watch?v=f4s1h2YETNY&ab_channel=kishimisu
void main()
{
    float _time = time - iTime;
    
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.y;
    uv.y /= -2.0;
    vec2 uv0 = uv;
    
    float eggs = 12.;
    float t = mod(_time, eggs);
    
    uv = fract(uv * 2.0) - 0.5;
    uv.x += t;
    uv.x = fract(uv.x + 0.5) - 0.5;
    uv.y = uv0.y * 1.0 - abs(uv0.y * 3.5);
    
    float d = length(uv);
    d -= 0.2;
    d = 1.0 - smoothstep(0.1, 0.11, d);
    
    vec3 col = palette(mod(round(uv0.x + t * 0.5), 0.5 * eggs)) * d;
    
    outColor = vec4(col, 1.0);
}