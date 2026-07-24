#version 150 core

/*
 * SHADER PACK SUPREME - Shadow Fragment Shader
 */

void main() {
    gl_FragDepth = gl_FragCoord.z;
}
