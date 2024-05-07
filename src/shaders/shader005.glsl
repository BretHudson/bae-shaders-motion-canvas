#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

float bounceMod(float v, float m)
{
    return abs(mod(abs(v), m) - m / 2.0);
}

float sdCircle(vec2 p, float r)
{
    return length(p) - r;
}

float antialias(float d)
{
    return smoothstep(1.0, -1.0, d / fwidth(d));
}

uniform float iTime;

void main()
{
    float _time = time - iTime;
    
    float PI = 3.141592;
    float TAU = PI * 2.0;
    
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    uv.y *= -1.0;
    vec2 uv0 = uv;

    float d1 = 1.0;
    float d2 = 1.0;
    float d3 = 1.0;
    float d4 = 1.0;
    
    float size = 0.05;
    vec2 dist = vec2(0.125, 0.025);
    float circleCount = 17.0;
    
    float t = mod(_time, 1.0);
    
    // Red parabola (U)
    float halfCount = floor(circleCount / 2.0);
    for (float i = -halfCount + t - 1.0; i <= halfCount + t; ++i)
    {
        uv.x = uv0.x - i * dist.x;
        uv.y = uv0.y - abs(i * i * dist.y) + 0.25;
        float s = size * abs(i) / 3.0;
        d1 = min(d1, sdCircle(uv, s));
    }
    
    // Green parabola (^)
    for (float i = -halfCount + t - 1.0; i <= halfCount + t; ++i)
    {
        uv.x = uv0.x - i * dist.x;
        uv.y = uv0.y + abs(i * i * dist.y);
        uv.y -= 0.25;
        d2 = min(d2, length(uv) - size * ((1.5 + abs(i)) / 7.0));
    }
    
    // Pink sin wave
    for (float i = -halfCount + t - 1.0; i <= halfCount + t; ++i)
    {
        uv.x = uv0.x - i * dist.x;
        uv.y = uv0.y + sin(i + _time) * 0.2;
        float s = size * (0.3 + 0.9 / (0.7 + abs(i)));
        d3 = min(d3, length(uv) - s);
    }
    
    // Orange circle of bubbles
    t = _time * 1.5;
    for (float i = -halfCount + t - 1.0; i <= halfCount + t + 1.01; ++i)
    {
        float r = 0.65;
        float s = abs(sin(i)) * (4.5 + abs(bounceMod(i, 70.0))) / 7.0;
        float a = i / circleCount * TAU * 2.0;
        uv.x = uv0.x - cos(a) * r;
        uv.y = uv0.y - sin(a) * r;
        d4 = min(d4, length(uv) - size * s);
    }
    
    
    d1 = antialias(d1);
    d2 = antialias(d2);
    d3 = antialias(d3);
    d4 = antialias(d4);
   
    vec3 col = vec3(0.5 + d1 * 0.7 + d2 * 0.3 + d3 * 0.7 + d4 * 0.4,
                    0.5 + d1 * 0.2 + d2 * 0.8 + d3 * 0.4 + d4 * 0.3,
                    0.5 + 0.2 + d3 * 0.8 + d4 * 0.0);

    // Output to screen
    outColor = vec4(col, 1.0);
}