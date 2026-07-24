#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Terrain Fragment Shader (FIXED)
 * Simple, reliable PBR without visibility issues
 */

uniform sampler2D texture;
uniform sampler2D lightmap;

in vec2 texCoord;
in vec2 lmCoord;
in vec3 normal;
in vec4 color;
in vec4 viewPos;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;
layout(location = 2) out vec4 colortex2;
layout(location = 3) out vec4 colortex3;

#define PI 3.14159265359

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

void main() {
    vec4 texColor = texture(texture, texCoord) * color;
    
    if (texColor.a < 0.5) discard;
    
    vec3 baseColor = texColor.rgb;
    
    // Get lightmap
    vec3 lightColor = texture(lightmap, lmCoord).rgb;
    
    // Simple lighting: base color * lightmap
    // This ensures everything is visible
    vec3 finalColor = baseColor * lightColor;
    
    // Add ambient light to prevent complete darkness
    finalColor = max(finalColor, baseColor * 0.4);
    
    // Brighten slightly
    finalColor = finalColor * 1.1;
    
    // Output to G-buffers
    colortex0 = vec4(finalColor, 1.0);
    colortex1 = vec4(normalize(normal) * 0.5 + 0.5, 0.5);
    colortex2 = vec4(baseColor, 0.0);
    colortex3 = vec4(vec3(1.0), 1.0);
}
