#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Terrain Vertex Shader
 * Simple and reliable vertex processing
 */

uniform mat4 gbufferModelMatrix;
uniform mat4 gbufferModelViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform mat4 shadowModelMatrix;
uniform mat4 shadowProjectionMatrix;

uniform vec3 chunkOffset;

in vec3 vaPosition;
in vec2 vaTexCoord;
in vec3 vaNormal;
in vec4 vaColor;
in ivec2 vaLightCoord;

out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 color;
out vec3 shadowPos;
out vec4 viewPos;

void main() {
    vec3 worldPos = vaPosition + chunkOffset;
    
    viewPos = gbufferModelViewMatrix * vec4(worldPos, 1.0);
    gl_Position = gbufferProjectionMatrix * viewPos;
    
    vec4 shadowViewPos = shadowModelMatrix * vec4(worldPos, 1.0);
    shadowPos = (shadowProjectionMatrix * shadowViewPos).xyz * 0.5 + 0.5;
    
    texCoord = vaTexCoord;
    lmCoord = vaLightCoord / 256.0;
    normal = normalize(mat3(gbufferModelViewMatrix) * vaNormal);
    color = vaColor;
}
