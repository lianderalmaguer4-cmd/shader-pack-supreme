#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Shadow Fragment Shader
 */

void main() {
    gl_FragDepth = gl_FragCoord.z;
}
