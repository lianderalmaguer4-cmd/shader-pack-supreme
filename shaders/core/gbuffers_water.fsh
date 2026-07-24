#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Water Fragment Shader (FIXED)
 * Simple water with good visibility
 */

uniform sampler2D texture;
uniform sampler2D depthtex0;

in vec2 texCoord;
in vec3 normal;
in vec4 color;
in vec4 viewPos;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;

float fresnelEffect(vec3 N, vec3 V) {
    float cosTheta = abs(dot(N, V));
    float fresnel = pow(1.0 - cosTheta, 5.0);
    return mix(0.04, 1.0, fresnel);
}

void main() {
    vec3 N = normalize(normal);
    vec3 V = normalize(-viewPos.xyz);
    
    float fresnel = fresnelEffect(N, V);
    
    // Water color
    vec3 waterColor = color.rgb;
    
    // Add blue tint for water
    waterColor = mix(waterColor, vec3(0.2, 0.5, 0.8), 0.3);
    
    // Simple lighting
    vec3 finalColor = waterColor * (0.8 + fresnel * 0.3);
    
    // Add transparency effect
    float alpha = 0.7;
    
    colortex0 = vec4(finalColor, alpha);
    colortex1 = vec4(N * 0.5 + 0.5, 1.0);
}
