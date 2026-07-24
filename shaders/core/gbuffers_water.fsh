#version 150 core

/*
 * SHADER PACK SUPREME - Water Fragment Shader
 * Refracción, reflexión, profundidad
 */

uniform sampler2D texture;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform samplerCube reflection;

uniform float waterRefractionStrength;
uniform float waterReflectionStrength;
uniform float waterTransparency;
uniform float waterNormalStrength;
uniform float waterSpecular;

in vec2 texCoord;
in vec3 normal;
in vec4 color;
in vec4 viewPos;
in vec3 vertexPos;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;

#define PI 3.14159265359

// ====== WATER NORMAL ======

vec3 getWaterNormal() {
    // Normal perturbado para mayor realismo
    vec3 norm = normalize(normal);
    
    vec3 perturbation = vec3(
        sin(texCoord.x * 5.0 + vertexPos.y * 0.1) * 0.05,
        0.0,
        cos(texCoord.y * 5.0 + vertexPos.x * 0.1) * 0.05
    );
    
    norm = normalize(norm + perturbation * waterNormalStrength);
    return norm;
}

// ====== FRESNEL EFFECT ======

float fresnelEffect(vec3 N, vec3 V) {
    float cosTheta = abs(dot(N, V));
    float fresnel = pow(1.0 - cosTheta, 5.0);
    return mix(0.04, 1.0, fresnel);
}

// ====== UNDERWATER FOG ======

vec3 underwaterFog(vec3 color, float depth) {
    float fogDistance = depth * 2.0;
    float fogFactor = 1.0 - exp(-fogDistance * 0.1);
    
    vec3 fogColor = vec3(0.2, 0.5, 0.7); // Azul agua
    return mix(color, fogColor, fogFactor);
}

// ====== CAUSTICS PATTERN ======

vec3 caustics(vec2 uv, float time) {
    vec2 uv1 = uv + vec2(sin(uv.y * 3.0 + time) * 0.1, cos(uv.x * 3.0 + time) * 0.1);
    
    float pattern = sin(uv1.x * 10.0) * cos(uv1.y * 10.0);
    pattern = smoothstep(0.0, 1.0, pattern * 0.5 + 0.5);
    
    return vec3(pattern * 0.3);
}

void main() {
    vec3 waterColor = color.rgb;
    vec3 N = getWaterNormal();
    vec3 V = normalize(-viewPos.xyz);
    
    // Fresnel
    float fresnel = fresnelEffect(N, V);
    
    // Refracción simulada
    vec2 refractUV = texCoord + N.xz * waterRefractionStrength;
    vec3 refractColor = texture(texture, refractUV).rgb;
    refractColor = underwaterFog(refractColor, 0.5);
    
    // Reflexión (simulated)
    vec3 reflectDir = reflect(-V, N);
    vec3 reflectColor = vec3(0.5, 0.7, 1.0); // Sky color
    
    // Especularidad
    float specular = pow(max(dot(reflectDir, vec3(0.0, 1.0, 0.0)), 0.0), 32.0) * waterSpecular;
    
    // Caustics
    vec3 causticPattern = caustics(texCoord, 0.5);
    
    // Mezclar colores
    vec3 finalColor = mix(refractColor, reflectColor, fresnel) * waterReflectionStrength;
    finalColor += specular * vec3(1.0);
    finalColor += causticPattern * 0.2;
    finalColor = mix(finalColor, waterColor, waterTransparency);
    
    colortex0 = vec4(finalColor, 0.7);
    colortex1 = vec4(N * 0.5 + 0.5, 1.0);
}
