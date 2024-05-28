#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

uniform float iTime;

#define rot(a) mat2(cos(a), -sin(a), sin(a), cos(a))

float PI = 3.14159;
float EPSILON = 0.0001;

float sdCircle(vec2 p, float r)
{
    return length(p) - r;
}

// below two thanks to https://stackoverflow.com/questions/52958171/glsl-optimization-check-if-variable-is-within-range
float inRange(float a, float v, float b)
{
    return step(a, v) - step(b, v);
}

float compare(float v, float target)
{
    return inRange(target - EPSILON, v, target + EPSILON);
}

// below four functions thanks to https://www.ronja-tutorials.com/post/035-2d-sdf-combination/
float intersect(float shape1, float shape2)
{
    return max(shape1, shape2);
}
vec3 intersect(vec3 shape1, vec3 shape2)
{
    return max(shape1, shape2);
}

float merge(float shape1, float shape2)
{
    return min(shape1, shape2);
}

vec3 merge(vec3 shape1, vec3 shape2)
{
    return min(shape1, shape2);
}

float subtract(float base, float subtraction)
{
    return intersect(base, -subtraction);
}
vec3 subtract(vec3 base, vec3 subtraction)
{
    return intersect(base, -subtraction);
}

float edge(float d, float d2)
{
    d2 += 0.06;
    float thickness = 0.01;
    float maxThick = 0.015;
    return pow((maxThick - (maxThick - thickness) * sign(d2)) / abs(d), 1.5);
}

void main()
{
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    
	float _time = time - iTime;
	
    float initialRot = 2.3;
    
    vec2 _uv = uv;
    _uv *= rot(-(initialRot + _time) + PI / 3.);
    
    float a = inRange(PI / 3., atan(_uv.y, _uv.x), PI);
    float b = inRange(-PI, atan(_uv.y, _uv.x), -PI / 3.);
    float c = inRange(-PI / 3., atan(_uv.y, _uv.x), PI / 3.);
    
    vec3 outerCircles = vec3(0);
    
    float innerD = sdCircle(uv, 0.5);
    
    vec3 col = vec3(0);
    
    float numCircles = 3.;
    vec2 offset = vec2(1., 0.);
    offset *= rot(initialRot + _time);
    offset *= (cos(1.9 + _time) + 1.) / 5. + 0.4;
    
    float outerD = 1.;
    
    for (float i = 0.; i < numCircles; ++i)
    {
        offset *= rot(PI * 2. / numCircles);
        float d = sdCircle(uv + offset, 0.3);
        outerD = merge(d, outerD);
    }
    
    float outer = subtract(outerD, innerD);
    float overlap = intersect(outerD, innerD);
    float inner = subtract(innerD, outerD);
    
    col += edge(outer, innerD) * vec3(
        c + b,
        a + b,
        a + c
    );
    col += edge(overlap, innerD) * vec3(
        a, c, b
    );
    
    col += edge(inner, innerD + 0.06) * vec3(1.);
    
    outColor = vec4(col, 1.0);
}