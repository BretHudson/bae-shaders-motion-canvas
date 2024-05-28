#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

uniform float iTime;

#define rot(a) mat2(cos(a), sin(a), -sin(a), cos(a))

float PI = 3.14159;
float SQRT_3 = 1.73205;

// coded this myself, probably not good :)
float drawHexagon(vec2 p, float r)
{
    float HEX_SIXTH = PI / 3.;
    
    float a = atan(p.y, p.x);
    
    float isLeft = step(0., abs(a) - HEX_SIXTH * 2.0);
    float isRght = step(0., HEX_SIXTH - abs(a));
    float isFlat = 1. - sign(isLeft + isRght);
    
    float y = isLeft * (SQRT_3 * p.x + 2. * r) +
              isFlat * r +
              isRght * (-SQRT_3 * p.x + 2. * r);
    
    isFlat *= SQRT_3;
    
    return (abs(p.y) - y) * (isFlat + isLeft + isRght);
}

float hexOutline(vec2 p, float r)
{
    float d = drawHexagon(p, r);
    d = smoothstep(-1., 1., d / fwidth(d));
    return d;
}

void main()
{
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    uv *= 2.;
    
	float _time = time - iTime;
	
    float t = _time * 3. + 53.7;
    float r = 5.5;
    
    float d = 0.;
    d = hexOutline(uv, r);
    
    vec3 base = vec3(0.2);
    vec3 col = 1. - base;
    
    float steps = 6.;
    float inc = 1.65;
    for (float i = 0.; i < steps; ++i)
    {
        vec2 p = uv * rot(t);
        r /= inc;
        t += 0.17;
        t *= 0.17;
        uv *= rot(t);
        d = hexOutline(uv, r);
        col -= max(0., d) * vec3(0.8, 0.6, 0.2) / steps;
    }

    outColor = vec4(col,1.0);
}