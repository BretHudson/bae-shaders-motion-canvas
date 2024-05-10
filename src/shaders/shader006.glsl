#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

// kudos to IQ for signed distance functions
// https://iquilezles.org/articles/distfunctions2d/

float sdRoundedX( in vec2 p, in float w, in float r )
{
    p = abs(p);
    return length(p-min(p.x+p.y,w)*0.5) - r;
}

// kudos to https://www.ronja-tutorials.com/post/035-2d-sdf-combination/
vec2 rotate(in vec2 p, in float rot)
{
    float PI = 3.14159;
    float angle = rot * PI * 2.0 * -1.0;
    float sine = sin(angle);
    float cosine = cos(angle);
    return vec2(cosine * p.x + sine * p.y, cosine * p.y - sine * p.x);
}

vec3 palette(in float t)
{
    vec3 a = vec3(0.731, 1.098, 0.192);
    vec3 b = vec3(0.358, 1.090, 0.657);
    vec3 c = vec3(1.077, 0.360, 0.328);
    vec3 d = vec3(0.965, 2.265, 0.837);
    return a + b * cos(6.28318 * (c * t + d));
}

float edge(in float d, in float a, in float b)
{
    return 1.0 - smoothstep(a, b, d);
}

float circles = 6.0;

float lerp(in float a, in float b, in float t)
{
    return a * (1.0 - t) + b * t;
}

uniform float iTime;

float renderShapeAnim(in vec2 pos, in float size, in float rotation, in float tOffset)
{
    float _time = time - iTime;
    float t = (_time + tOffset);
    
    float edgeR = 0.0;
    float pulse = sin(t) * 0.5 + 0.5;
    
    vec2 aPos = rotate(pos, t * 0.3 + rotation);
    vec2 bPos = rotate(pos, rotation);
    float shapeA = sdRoundedX(aPos, size, size / 5.0);    
    float shapeB = sdRoundedX(bPos, size, size / 5.0);
    
    float d = lerp(shapeA, shapeB, pulse);
    d = edge(d, edgeR, edgeR + 0.2 * (size / 3.0));
    
    return d;
}

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.y;
    vec2 uv0 = uv;
	
	float a = 3.14159 / 2.;
	uv *= mat2(cos(a), -sin(a), sin(a), cos(a));
    
    //uv *= 0.5625;
	//uv *= 0.9;
    
    vec3 color = vec3(0., 0., .2);
    vec3 colorMask = vec3(1., .1, .7);
    
    float d = renderShapeAnim(uv, 0.3, 0.0, 0.0);
    color += colorMask * d;
    
    float offset = 1.0 / 1.75;
    float yOffset = offset * 0.6666;
    d = renderShapeAnim(uv + vec2(offset, yOffset), 0.3, 0.0, 0.0);
    color += colorMask * d;
    d = renderShapeAnim(uv + vec2(-offset, yOffset), 0.3, 0.0, 0.0);
    color += colorMask * d;
    d = renderShapeAnim(uv + vec2(-offset, -yOffset), 0.3, 0.0, 0.0);
    color += colorMask * d;
    d = renderShapeAnim(uv + vec2(offset, -yOffset), 0.3, 0.0, 0.0);
    color += colorMask * d;
    d = renderShapeAnim(uv + vec2(offset * 2.0, 0.0), 0.3, 0.0, 0.0);
    color += colorMask * d;
    d = renderShapeAnim(uv + vec2(-offset * 2.0, 0.0), 0.3, 0.0, 0.0);
    color += colorMask * d;
    
    uv *= 3.;
    for (float i = 1.0; i < 3.0; i++)
    {
        uv = fract(uv * 1.75) - 0.5;
        
        float d = 0.0;
        
        for (int y = -1; y <= 1; ++y)
        {
            for (int x = -1; x <= 1; ++x)
            {
                vec2 offset = vec2(x, y);
                float size = 0.27 - i * 0.03;
                float rot = i * 0.125;
                float tOffset = i * -0.85;
                float opacity = 1.1 / (i + 1.0);
                d = max(d, renderShapeAnim(uv, size, rot, tOffset) * opacity);
                float threshold = 0.493;
                if (uv.x > threshold || uv.y > threshold || uv.x < -threshold || uv.y < -threshold)
                {
                    d = 1.0;
                }
            }
        }
        color += colorMask * d;
        color.rb += vec2(-1.) * .5;
    }
    outColor = vec4(color, 1.0);
}