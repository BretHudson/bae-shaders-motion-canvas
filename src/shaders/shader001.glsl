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
	// Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.y;
    uv.y *= -1.0;
    uv *= 4.5;
    
    float t = time - floor(time);
    float d = distance(uv - vec2(t, 0), vec2(round(uv.x - t), 0));//round(length(uv.x) - floor(uv.x));
    d *= 0.1;
    d -= 0.1 * cos(abs(uv.x) / 4.0);
    d = abs(d);
    d = pow(0.01 / d, 1.5) - 0.3;
    
    float percent = sourceUV.x;
    float cycles = 16.0;
    
    float palettePercent = round(percent * cycles) / cycles;
    float paletteT = palettePercent - time * 0.1;
    
    float alpha = sin(round(percent * cycles) / 3.14 * cycles * 8.0) * 0.35 + 0.65;
    vec3 col = palette(paletteT) * d * alpha;
    
    // Output to screen
    outColor = vec4(col, 1.0);
}