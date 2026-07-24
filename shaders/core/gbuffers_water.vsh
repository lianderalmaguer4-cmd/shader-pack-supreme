#version 150 core

/*
 * SHADER PACK SUPREME v3.0 - Water Vertex Shader
 * Simple wave animation
 */

uniform mat4 gbufferModelViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform vec3 chunkOffset;
uniform float frameTimeCounter;

uniform float waveAmplitude;
uniform float waveSpeed;

in vec3 vaPosition;
in vec2 vaTexCoord;
in vec3 vaNormal;
in vec4 vaColor;

out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec4 viewPos;

vec3 gerstnerWave(vec4 wave, vec3 p) {
    float steepness = wave.z;
    float wavelength = wave.w;
    float k = 2.0 * 3.14159265 / wavelength;
    float c = sqrt(9.8 / k);
    vec2 d = normalize(wave.xy);
    float f = k * (dot(d, p.xz) - c * frameTimeCounter * waveSpeed);
    float a = steepness / k;
    
    return vec3(
        d.x * (a * cos(f)),
        a * sin(f),
        d.y * (a * cos(f))
    );
}

void main() {
    vec3 pos = vaPosition + chunkOffset;
    
    // Apply waves
    pos += gerstnerWave(vec4(1.0, 0.0, 0.25, 60.0), pos) * waveAmplitude;
    pos += gerstnerWave(vec4(0.2, 0.4, 0.15, 31.0), pos) * waveAmplitude * 0.5;
    
    viewPos = gbufferModelViewMatrix * vec4(pos, 1.0);
    gl_Position = gbufferProjectionMatrix * viewPos;
    
    texCoord = vaTexCoord + vec2(frameTimeCounter * waveSpeed * 0.02);
    normal = normalize(mat3(gbufferModelViewMatrix) * vaNormal);
    color = vaColor;
}
