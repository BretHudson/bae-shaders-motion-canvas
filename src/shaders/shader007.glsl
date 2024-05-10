#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

float hash(vec2 p)
{
    p = fract(p * vec2(123.345, 734.6897));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float drawCircle(vec2 gv, float time, vec2 offset, float yDir, vec2 id)
{
    float n = hash(id);
    float t = floor(time);
    offset -= vec2(t, t * yDir);
    vec2 jitter = vec2(time - 0.5, yDir * (time - 0.5)) + 0.5 * vec2(hash(id + offset));
    
    vec2 pos = gv - jitter - offset;
    
    float size = 0.15 + 0.1 * sin(n * 40.0 + time);
    float d = length(pos) - size;
    float m = 0.05 / abs(d);

    return max(0., m * smoothstep(0.4, 0.2, d)) * .7;
}

uniform float iTime;

void main()
{
    float _time = time - iTime;
    
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    
    uv *= 1.5;
    
    uv += .5;
    uv.x -= 1.0;
    
    float startTime = 35.9;
    float _iTime = _time + startTime;
    
    vec2 gv = fract(uv) - .5;
    vec2 id = floor(uv);
    float n = hash(id);

    vec3 col = vec3(0., 0., 0.2);
    
    float tScale = 0.3 + sin(_iTime) * 0.002;
    float _iTime2 = _iTime * tScale + 1.3;
    
    for (float y = -1.; y <= 1.; ++y)
    {
        for (float x = -1.; x <= 1.; ++x)
        {
            float m = drawCircle(gv, _iTime, vec2(x, y), 1., id);
            col += m * vec3(.7, .4, .0);
            m = drawCircle(gv, _iTime2, vec2(x, y), -1., id);
            col += m * vec3(1.0, 0.4, .6);
        }
    }
    
    float val = max(gv.x, gv.y) - .46;
    if (val > 0.) col += val * 2.;

    outColor = vec4(col, 1.0);
}