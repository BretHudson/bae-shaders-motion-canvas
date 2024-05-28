#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

uniform float iTime;

#define PI 3.14159
#define rot(at) mat2(cos(at), -sin(at), sin(at), cos(at))

// kudos to https://www.shadertoy.com/view/XljGzV
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float sdCircle(vec2 p, float r)
{
    return length(p) - r;
}

float smin(float a, float b, float k)
{
    float h = max(k - abs(a - b), 0.) / k;
    return min(a, b) - h * h * h * k * (1. / 6.);
}

float antialias(in float d)
{
    return smoothstep(1.0, -1.0, d / fwidth(d));
}

float drawRing(vec2 uv, float n, float ringRadius, float dRadius)
{
    float phi = (2. * PI) / n;
    
    float d = 1.;
    // make sure neighbors aren't getting clipped
    for (float i = -1.; i < 1.1; ++i)
    {
        float offset = i * (2. * PI / n);
        vec2 _uv = uv * rot(offset);
        float l = length(_uv);
        float r = atan(_uv.y, _uv.x);

        float iter = (n * floor(n * r / (2. * PI))) / n + iTime * PI;

        float rr = mod(r, phi) - (phi * .5) - offset;

        vec2 p = vec2(cos(rr), sin(rr)) * l;

        float xx = 1. + .05 * sin(iter * 1.3);
        d = min(d, distance(p, vec2(ringRadius, 0.) * xx) - dRadius);
    }
    
    return d;
}

float lerp(float a, float b, float t)
{
    return a + (b - a) * t;
}

float wave(float a, float b, float t)
{
    return lerp(a, b, (cos(t) + 1.) / 2.);
}

void main()
{
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
	
    float tOffset = 4.3;
    float t = time - iTime + tOffset;
    
    float at = t * 0.25;
    uv *= rot(at);
    
    float circleRadius = 0.125;
    
    float center = sdCircle(uv, circleRadius * 1.);
    
    float c = (cos(t) + 1.) / 2.;
    
    float dist = 0.5;
    
    float r1 = drawRing(uv, 6.,
        c,
        circleRadius);
    float r2 = drawRing(uv, 12.,
        wave(dist + 0.125, 1.125, t),
        circleRadius * 0.85);
    float r3 = drawRing(uv, 24.,
        (2. * dist + c) * 0.9,
        circleRadius * 1.);
    float r4 = drawRing(uv, 48.,
        wave(3. * dist + 0.125, 2.125, t),
        circleRadius * 0.75);
    
    float d = smin(center, r1, 0.5);
    d = smin(d, r2, 0.5);
    d = smin(d, r3, 0.5);
    d = smin(d, r4, 0.7);
    d = antialias(d);
    
    float a = atan(uv.y, uv.x) + length(uv) * 1.;
    a /= 2. * PI;
    a += length(uv) * length(uv) * 0.1;
    vec3 hue = hsv2rgb(vec3(a, length(uv) * 0.175 * (sin(t) + 5.5), 1.));
    
    vec3 col = vec3(0.);
    col += max(d, 0.3) * hue;

    outColor = vec4(col, 1.0);
}