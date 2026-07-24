#version 150 core

/*
 * SHADER PACK SUPREME v2.0 - Terrain Fragment Shader (FIXED)
 * Physically Based Rendering (PBR) con shadows
 * BUG FIX: Colores más visibles, mejor iluminación
 */

// Uniforms
uniform sampler2D texture;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D lightmap;
uniform sampler2D normals;

uniform float shadowDistance;
uniform float shadowFadeStart;
uniform float shadowStrength;
uniform float roughness;
uniform float metallic;
uniform float ambientOcclusion;
uniform float normalMapStrength;

uniform vec3 sunPosition;
uniform vec3 sunColor;
uniform vec3 moonColor;
uniform float timeOfDay;

// Input
in vec2 texCoord;
in vec2 lmCoord;
in vec3 normal;
in vec4 color;
in vec3 shadowPos;
in vec4 viewPos;

// Output
layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;
layout(location = 2) out vec4 colortex2;
layout(location = 3) out vec4 colortex3;

#define PI 3.14159265359
#define SHADOW_SAMPLES 32

// ====== SHADOW MAPPING ======

float shadowMapping() {
    vec3 shadowCoord = shadowPos;
    
    if (shadowCoord.x < 0.0 || shadowCoord.x > 1.0 ||
        shadowCoord.y < 0.0 || shadowCoord.y > 1.0 ||
        shadowCoord.z < 0.0 || shadowCoord.z > 1.0) {
        return 1.0;
    }
    
    float shadow = 0.0;
    float shadowSampleSize = 1.0 / 2048.0;
    
    for (int i = 0; i < SHADOW_SAMPLES; i++) {
        float angle = float(i) / float(SHADOW_SAMPLES) * 6.28318;
        float radius = float(i) / float(SHADOW_SAMPLES) * shadowSampleSize * 4.0;
        
        vec2 offset = vec2(cos(angle), sin(angle)) * radius;
        float depth = texture(shadowtex0, shadowCoord.xy + offset).r;
        
        shadow += shadowCoord.z < depth ? 1.0 : 0.5;
    }
    
    shadow /= float(SHADOW_SAMPLES);
    float fade = smoothstep(shadowFadeStart, shadowDistance, length(viewPos));
    shadow = mix(shadow, 1.0, fade);
    
    return mix(1.0, shadow, shadowStrength);
}

// ====== NORMAL MAPPING ======

vec3 normalMapping() {
    vec3 norm = normalize(normal);
    
    vec3 normalMap = normalize(vec3(
        sin(texCoord.x * 10.0) * 0.1,
        sin(texCoord.y * 10.0) * 0.1,
        1.0
    )) * normalMapStrength;
    
    norm = normalize(norm + normalMap);
    return norm;
}

// ====== PBR LIGHTING (MEJORADO) ======

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    return F0 + (1.0 - F0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}

float DistributionGGX(vec3 N, vec3 H, float roughness) {
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;
    
    float nom = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = PI * denom * denom;
    
    return nom / max(denom, 0.001);
}

float GeometrySchlickGGX(float NdotV, float roughness) {
    float r = (roughness + 1.0);
    float k = (r * r) / 8.0;
    
    float nom = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    
    return nom / max(denom, 0.001);
}

float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness) {
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2 = GeometrySchlickGGX(NdotV, roughness);
    float ggx1 = GeometrySchlickGGX(NdotL, roughness);
    
    return ggx1 * ggx2;
}

vec3 calculateLighting(vec3 baseColor, vec3 N, vec3 V) {
    vec3 F0 = mix(vec3(0.04), baseColor, metallic);
    
    vec3 lightDir = normalize(sunPosition);
    vec3 H = normalize(V + lightDir);
    
    float shadow = shadowMapping();
    
    // Luz más fuerte para mejor visibilidad
    float distance = 1.0;
    float attenuation = 1.5 / (distance * distance);
    vec3 radiance = sunColor * attenuation * shadow;
    
    float NDF = DistributionGGX(N, H, roughness);
    float G = GeometrySmith(N, V, lightDir, roughness);
    vec3 F = fresnelSchlick(clamp(dot(H, V), 0.0, 1.0), F0);
    
    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;
    
    float NdotL = max(dot(N, lightDir), 0.0);
    
    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, V), 0.0) * max(NdotL, 0.001);
    vec3 specular = numerator / max(denominator, 0.001);
    
    vec3 Lo = (kD * baseColor / PI + specular) * radiance * NdotL;
    
    // Ambient mejorado para evitar oscuridad
    vec3 ambient = baseColor * 0.15 * ambientOcclusion;
    
    return ambient + Lo;
}

// ====== MAIN ======

void main() {
    vec4 texColor = texture(texture, texCoord) * color;
    
    if (texColor.a < 0.1) discard;
    
    vec3 baseColor = texColor.rgb;
    
    // Asegurar que el color base no sea demasiado oscuro
    baseColor = max(baseColor, vec3(0.1));
    
    vec3 N = normalMapping();
    vec3 V = normalize(-viewPos.xyz);
    
    vec3 litColor = calculateLighting(baseColor, N, V);
    
    // Lightmap influence mejorada
    vec3 lmColor = max(texture(lightmap, lmCoord).rgb, vec3(0.3));
    litColor = mix(litColor, baseColor * lmColor, 0.4);
    
    // Asegurar visibilidad mínima
    litColor = max(litColor, vec3(0.1));
    
    colortex0 = vec4(litColor, 1.0);
    colortex1 = vec4(N * 0.5 + 0.5, roughness);
    colortex2 = vec4(baseColor, metallic);
    colortex3 = vec4(vec3(ambientOcclusion), 1.0);
}
