#version 150 core

/*
 * SHADER PACK SUPREME - Terrain Vertex Shader
 * Shadow mapping y geometría detallada
 */

// Uniforms
uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferModelViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform mat4 shadowModelMatrix;
uniform mat4 shadowProjectionMatrix;

uniform vec3 chunkOffset;
uniform float frameTimeCounter;

// Input
in vec3 vaPosition;
in vec2 vaTexCoord;
in vec2 vaTexCoordAnim;
in vec3 vaNormal;
in vec4 vaColor;
in ivec2 vaLightCoord;

// Output
out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 color;
out vec3 shadowPos;
out vec4 viewPos;

void main() {
    // Posición en view space
    viewPos = gbufferModelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    gl_Position = gbufferProjectionMatrix * viewPos;
    
    // Shadow position
    vec4 shadowViewPos = shadowModelMatrix * vec4(vaPosition + chunkOffset, 1.0);
    shadowPos = (shadowProjectionMatrix * shadowViewPos).xyz * 0.5 + 0.5;
    
    // Texture coordinates
    texCoord = vaTexCoord;
    
    // Lightmap coordinates (normalizar a 0-1)
    lmCoord = vaLightCoord / 256.0;
    
    // Normal
    normal = normalize(mat3(gbufferModelViewMatrix) * vaNormal);
    
    // Vertex color
    color = vaColor;
}
