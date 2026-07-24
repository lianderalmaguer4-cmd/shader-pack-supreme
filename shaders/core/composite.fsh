#version 150 core

/*
 * SHADER PACK SUPREME v2.0 - Composite Fragment Shader (FIXED)
 * Post-processing effects: Bloom, Tone Mapping, God Rays
 * BUG FIX: Visibilidad mejorada, colores corregidos
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

// ====== BLOOM (MEJORADO) ======

vec3 bloom(vec2 uv) {
    vec3 color = texture(colortex0, uv).rgb;
    
    // Evitar bloom si el color es muy oscuro
    float brightness = dot(color, vec3(0.299, 0.587, 0.114));
    if (brightness < 0.1) return color;
    
    vec3 bloom_acc = vec3(0.0);
    float pixelSize = bloomRadius / 256.0;
    
    for (int i = 0; i < BLOOM_SAMPLES; i++) {
        float angle = (float(i) / float(BLOOM_SAMPLES)) * PI * 2.0;
        float radius = float(i + 1) * pixelSize;
        
        vec2 offset = vec2(cos(angle), sin(angle)) * radius;
        vec3 sampleColor = texture(colortex0, uv + offset).rgb;
        
        float sampleBrightness = dot(sampleColor, vec3(0.299, 0.587, 0.114));
        
        if (sampleBrightness > bloomThreshold) {
            bloom_acc += sampleColor * (1.0 - float(i) / float(BLOOM_SAMPLES));
        }
    }
    
    return color + bloom_acc * bloomIntensity * 0.05;
}

// ====== GOD RAYS (MEJORADO) ======

vec3 godRays(vec2 uv) {
    vec2 sunPos = vec2(0.85, 0.85);
    vec2 rayDir = normalize(sunPos - uv);
    
    vec3 godray = vec3(0.0);
    vec2 rayStep = rayDir * (1.0 / float(GODRAY_SAMPLES));
    
    float rayCount = 0.0;
    for (int i = 0; i < GODRAY_SAMPLES; i++) {
        vec2 sampleUv = uv + rayStep * float(i);
        
        if (sampleUv.x < 0.0 || sampleUv.x > 1.0 || 
            sampleUv.y < 0.0 || sampleUv.y > 1.0) continue;
        
        float depth = texture(depthtex0, sampleUv).r;
        
        if (depth > 0.9) {
            vec3 sample = texture(colortex0, sampleUv).rgb;
            float brightness = dot(sample, vec3(0.299, 0.587, 0.114));
            
            if (brightness > 0.3) {
                float falloff = 1.0 - float(i) / float(GODRAY_SAMPLES);
                godray += sample * brightness * falloff * 0.3;
                rayCount += 1.0;
            }
        }
    }
    
    if (rayCount > 0.0) {
        godray /= rayCount;
    }
    
    return godray * godrayIntensity * 0.05;
}

// ====== TONE MAPPING (MEJORADO - MENOS AGRESIVO) ======

vec3 toneMap(vec3 color) {
    // ACES Filmic adaptado para mejor visibilidad
    vec3 a = vec3(2.51);
    vec3 b = vec3(0.03);
    vec3 c = vec3(2.43);
    vec3 d = vec3(0.59);
    vec3 e = vec3(0.14);
    
    color = (color * (a * color + b)) / (color * (c * color + d) + e);
    
    // IMPORTANTE: Limitar el darkening
    color = clamp(color, vec3(0.1), vec3(1.0));
    
    // Aplicar tone mapping strength de forma controlada
    color = mix(vec3(dot(color, vec3(0.299, 0.587, 0.114))), color, 0.8 + toneMapingStrength * 0.2);
    
    return color;
}

// ====== SATURACIÓN ======

vec3 adjustSaturation(vec3 color) {
    vec3 hsv = rgb2hsv(color);
    hsv.y *= clamp(saturation, 0.3, 2.0);
    return hsv2rgb(hsv);
}

// ====== MAIN ======

void main() {
    vec2 uv = texCoord;
    
    // Color base
    vec3 color = texture(colortex0, uv).rgb;
    
    // Proteger contra colores completamente negros
    if (dot(color, color) < 0.001) {
        fragColor = vec4(color, 1.0);
        return;
    }
    
    // Aplicar post-processing con moderación
    color = bloom(uv) * 0.5 + color * 0.5;  // Reducido de 0.8 + 0.2
    color += godRays(uv) * 0.3;
    color = toneMap(color);
    color = adjustSaturation(color);
    
    // Asegurar que el color no sea demasiado oscuro
    color = max(color, vec3(0.1));
    
    fragColor = vec4(color, 1.0);
}
