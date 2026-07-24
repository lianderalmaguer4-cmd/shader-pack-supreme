#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Composite Fragment Shader (FIXED COMPLETE)
 * Simplified post-processing - NO visibility issues
 * Clean and bright rendering
 */

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;

in vec2 texCoord;

out vec4 fragColor;

void main() {
    // Simply read the color and output it
    // No aggressive post-processing
    vec3 color = texture(colortex0, texCoord).rgb;
    
    // Minimal brightness boost
    color = color * 1.05;
    
    // Clamp to prevent issues
    color = clamp(color, vec3(0.0), vec3(1.0));
    
    fragColor = vec4(color, 1.0);
}
