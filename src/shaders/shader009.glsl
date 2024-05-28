#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

uniform float iTime;

void main()
{
    float _time = time - iTime;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    vec2 uv0 = uv;

    vec3 col = vec3(0.0);
    
    uv *= 30.0;
    
    float uvOffset = 5.0;
    float uvSpeed = _time * 1.5;
    uv += vec2(uvSpeed * 1.2, sin(uvSpeed)) * uvOffset;
    
    uv = mod(uv, 10.0) - 5.0;
    
    float scale = 1.0;
    float tScale = 1.3;
    float startT = 1.5 * (3.141592 / tScale);
    float t = sin((_time + startT) * tScale) * scale + scale + 2.75;
    
    float d = mod(length(uv), t) - 0.5;
    
    // I really don't know what I'm doing here, but I wanted a thicc line
    d = smoothstep(3.9, -1.0, 1.0 * abs(d) / fwidth(d));
    
    float a = (length(uv0) - 0.76 + sin(_time) * 0.2);

    // Time varying pixel color
    float x = .5;//sourceUV.x / resolution.x;
    float y = .5;//sourceUV.y / resolution.y;
    vec3 col1 = d * vec3(0.5 + x * 0.6, 0.5 + y * 0.1, 0.2);
    vec3 col2 = d * vec3(.3, x * 0.4, .7);
    
    float c = (cos(_time) + 1.) * 0.5;
    col = mix(col2, col1, c) * (1.0 - a);
    col += 0.1;

    // Output to screen
    outColor = vec4(col,1.0);
}