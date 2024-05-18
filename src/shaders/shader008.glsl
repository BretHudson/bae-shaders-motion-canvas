#version 300 es
precision highp float;

#include "@motion-canvas/core/shaders/common.glsl"

vec2 rotate(vec2 v, float a)
{
    float s = sin(a);
    float c = cos(a);
    return mat2(c, s, -s, c) * v;
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}


float PI = 3.141592;
float ease(float x)
{
    return -(cos(PI * x) - 1.) / 2.;
}

uniform float iTime;

// this is over an hour of trying a bunch of things, big ol' mess
void main()
{
    float _time = time - iTime;
	
    vec2 uv = (sourceUV * resolution.xy * 2.0 - resolution.xy) / resolution.x;
    //uv *= 4.5;
    // uv *= 1.5;
	uv.x *= -1.;
    
    vec3 col = vec3(1., 0.5, 0.4);
    
    float offset = -0.08;
    float width = 0.1;
    
	uv = rotate(uv, PI / 2.);
    vec2 line_uv = uv;
    
    float totalRotations = 2.0 * abs(round(uv.x)) + 2.0;
    
    float time_scale = 9.;
    float time = _time;
    float delay = 0.4;
    time = mod(delay + time - totalRotations * delay, time_scale);
    
    float scaleDur = 1.5;
    float rotateDur = time_scale - scaleDur;
    
    // this means disable from 0. to scaleDur, then enable from scaleDur to 5.
    float canRotate = step(scaleDur, time_scale - time);
    
    float scaleTime = 0.;
    
    float rotateDir = sign(floor((uv.x + 1.0) / 2.0) + sign(uv.x));
    rotateDir = sign(mod(uv.x, 2.0) - 1.0);
    float rotateTime = ease(time / rotateDur) * totalRotations;
    
    line_uv = rotate(line_uv, 3.14 * rotateTime * canRotate * rotateDir);
    line_uv = fract(line_uv * 2.0);
    line_uv = fract(line_uv * 2.0);
    
    vec2 goal = vec2(abs(line_uv.x), 0.15);
    
    float amount = distance(abs(line_uv), goal) - 0.5;
    amount -= offset;
    
    float d = sdBox(line_uv, vec2(1.0, 0.75));
    d = smoothstep(.01, -0.01, d/fwidth(d));
    col += vec3(0., 0.4, 0.5) * d;
    col *= vec3(1., 0.97 + sin(_time * PI / scaleDur) * 0.03, 1.);
    
    outColor = vec4(col,1.0);
}