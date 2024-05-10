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

float sdBox(in vec2 p, in vec2 b)
{
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float antialias(in float d)
{
    return smoothstep(1.0, -1.0, d / fwidth(d));
}

float circles = 6.0;

uniform float iTime;

void main()
{
    float _time = time - iTime;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    uv.y *= -1.0;
    uv *= 1.13;
    
    uv *= circles;
    
    float d = 1.0;
    
    float ooo = 1.75;
    uv.y += ooo;
    for (float i = -circles; i < circles; i += 1.0)
    {
        float curStep = round((uv.x + _time) / 2.0) - _time / 2.0;
        float xOffset = -curStep * 2.0;
        float yOffset = -abs(curStep) * abs(curStep) * 0.1;
        //yOffset = 0.0;
        vec2 cUV = uv;
        vec2 circlePos = cUV + vec2(xOffset, yOffset);
        d = min(d, distance(circlePos, vec2(0.0, cUV.y * cUV.y / 3.5)) - 0.75 * (1.0 - abs(curStep / circles)));
    }

    // Time varying pixel color
    vec3 col = palette(mod(round((uv.x + _time) / 2.0), 8.0));
    col *= antialias(d);

    // Output to screen
    outColor = vec4(col,1.0);
}