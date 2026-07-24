#version 150 core

/*
 * SHADER PACK SUPREME - Composite Fragment Shader
 * Post-processing effects: Bloom, Tone Mapping, God Rays
 * Calidad Alta | Realista | Configurable
 */

// Uniforms
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D noisetex;

uniform float viewWidth;
uniform float viewHeight;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform int frameCounter;

uniform float bloomIntensity;
uniform float bloomRadius;
uniform float bloomThreshold;
uniform float godrayIntensity;
uniform float godraySteps;
uniform float toneMapingStrength;
uniform float saturation;

// Entrada
in vec2 texCoord;

// Salida
out vec4 fragColor;

#define BLOOM_SAMPLES 8
#define GODRAY_SAMPLES 32
#define PI 3.14159265359

// ====== UTILIDADES ======

vec3 rgb2hsv(vec3 rgb) {
    vec3 hsv;
    float maxc = max(max(rgb.r, rgb.g), rgb.b);
    float minc = min(min(rgb.r, rgb.g), rgb.b);
    hsv.z = maxc;
    
    if (minc != maxc) {
        hsv.y = (maxc - minc) / maxc;
        float delta = maxc - minc;
        
        if (maxc == rgb.r)
            hsv.x = mod((rgb.g - rgb.b) / delta, 6.0) / 6.0;
        else if (maxc == rgb.g)
            hsv.x = ((rgb.b - rgb.r) / delta + 2.0) / 6.0;
        else
            hsv.x = ((rgb.r - rgb.g) / delta + 4.0) / 6.0;
    }
    
    return hsv;
}

vec3 hsv2rgb(vec3 hsv) {
    vec3 rgb;
    float c = hsv.z * hsv.y;
    float hh = hsv.x * 6.0;
    float x = c * (1.0 - abs(mod(hh, 2.0) - 1.0));
    
    if (hh < 1.0) rgb = vec3(c, x, 0.0);
    else if (hh < 2.0) rgb = vec3(x, c, 0.0);
    else if (hh < 3.0) rgb = vec3(0.0, c, x);
    else if (hh < 4.0) rgb = vec3(0.0, x, c);
    else if (hh < 5.0) rgb = vec3(x, 0.0, c);
    else rgb = vec3(c, 0.0, x);
    
    return rgb + (hsv.z - c);
}

// Ruido Perlin
float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), f);
}

// ====== BLOOM ======

vec3 bloom(vec2 uv) {
    vec3 color = texture(colortex0, uv).rgb;
    vec3 bloom_acc = vec3(0.0);
    
    float pixelSize = bloomRadius / 256.0;
    
    for (int i = 0; i < BLOOM_SAMPLES; i++) {
        float angle = (float(i) / float(BLOOM_SAMPLES)) * PI * 2.0;
        float radius = float(i + 1) * pixelSize;
        
        vec2 offset = vec2(cos(angle), sin(angle)) * radius;
        vec3 sampleColor = texture(colortex0, uv + offset).rgb;
        
        float brightness = dot(sampleColor, vec3(0.299, 0.587, 0.114));
        
        if (brightness > bloomThreshold) {
            bloom_acc += sampleColor * (1.0 - float(i) / float(BLOOM_SAMPLES));
        }
    }
    
    return color + bloom_acc * bloomIntensity * 0.1;
}

// ====== GOD RAYS ======

vec3 godRays(vec2 uv) {
    // Centro aproximado del sol (superior derecha)
    vec2 sunPos = vec2(0.85, 0.85);
    vec2 rayDir = normalize(sunPos - uv);
    
    vec3 godray = vec3(0.0);
    vec2 rayStep = rayDir * (1.0 / float(GODRAY_SAMPLES));
    
    for (int i = 0; i < GODRAY_SAMPLES; i++) {
        vec2 sampleUv = uv + rayStep * float(i);
        
        if (sampleUv.x < 0.0 || sampleUv.x > 1.0 || 
            sampleUv.y < 0.0 || sampleUv.y > 1.0) continue;
        
        float depth = texture(depthtex0, sampleUv).r;
        
        // Solo god rays en el cielo (depth > 0.9)
        if (depth > 0.9) {
            vec3 sample = texture(colortex0, sampleUv).rgb;
            float brightness = dot(sample, vec3(0.299, 0.587, 0.114));
            
            float falloff = 1.0 - float(i) / float(GODRAY_SAMPLES);
            godray += sample * brightness * falloff * 0.5;
        }
    }
    
    return godray * godrayIntensity * 0.1;
}

// ====== TONE MAPPING ======

vec3 toneMap(vec3 color) {
    // ACES Filmic Tone Mapping
    vec3 a = vec3(2.51);
    vec3 b = vec3(0.03);
    vec3 c = vec3(2.43);
    vec3 d = vec3(0.59);
    vec3 e = vec3(0.14);
    
    color = (color * (a * color + b)) / (color * (c * color + d) + e);
    color = clamp(color, vec3(0.0), vec3(1.0));
    
    return color;
}

// ====== SATURACIÓN ======

vec3 adjustSaturation(vec3 color) {
    vec3 hsv = rgb2hsv(color);
    hsv.y *= saturation;
    return hsv2rgb(hsv);
}

// ====== MAIN ======

void main() {
    vec2 uv = texCoord;
    
    // Color base
    vec3 color = texture(colortex0, uv).rgb;
    
    // Aplicar post-processing
    color = bloom(uv) * 0.8 + color * 0.2;
    color += godRays(uv);
    color = toneMap(color);
    color = adjustSaturation(color);
    
    fragColor = vec4(color, 1.0);
}
