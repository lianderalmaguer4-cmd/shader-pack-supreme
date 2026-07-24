#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Shadow Vertex Shader
 */

uniform mat4 shadowModelMatrix;
uniform mat4 shadowProjectionMatrix;
uniform vec3 chunkOffset;

in vec3 vaPosition;

void main() {
    vec3 pos = vaPosition + chunkOffset;
    gl_Position = shadowProjectionMatrix * shadowModelMatrix * vec4(pos, 1.0);
}
