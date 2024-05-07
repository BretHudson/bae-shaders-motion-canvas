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

// kudos to @kishimisu https://www.youtube.com/watch?v=f4s1h2YETNY&ab_channel=kishimisu
void main()
{
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.y;
    uv.y /= -2.0;
    vec2 uv0 = uv;
    //uv.x = fragCoord.x / iResolution.y * 2.0;
    
    float t = time - floor(time);
    //t = 0.0;
    
    uv = fract(uv * 2.0) - 0.5;
    uv.x += t;
    uv.x = fract(uv.x + 0.5) - 0.5;
    uv.y = uv0.y * 1.0 - abs(uv0.y * 3.5);
    //uv.y = 2.0;
    //uv.y *= 2.0;
    //vec2 _uv = uv;
    //uv.y = uv.y * 2.0;
    //uv.y = _uv.y * 6.0;
    //uv.x = abs(1.0 - (uv.x * 2.0));
    //uv.x = sin(uv.x * 3.14159);
    
    //outColor = vec4(abs(uv.x), 0.0, 0.0, 1.0);
    //return;
    
    float d = length(uv);
    d -= 0.2;
    //d = smoothstep(0.1, 0.11, d);
    d = 1.0 - smoothstep(0.1, 0.11, d);
    
    vec3 col = palette(round(uv0.x + t * 0.5)) * d;
    
    // Output to screen
    outColor = vec4(col, 1.0);
}