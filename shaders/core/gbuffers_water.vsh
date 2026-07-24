#version 150 core

/*
 * SHADER PACK SUPREME - Water Vertex Shader
 * Wavering y displacement dinámico
 */

uniform mat4 gbufferModelViewMatrix;
uniform mat4 gbufferProjectionMatrix;
uniform vec3 chunkOffset;
uniform float frameTimeCounter;

// Water wave parameters
uniform float waveAmplitude;
uniform float waveFrequency;
uniform float waveSpeed;

in vec3 vaPosition;
in vec2 vaTexCoord;
in vec3 vaNormal;
in vec4 vaColor;

out vec2 texCoord;
out vec3 normal;
out vec4 color;
out vec4 viewPos;
out vec3 vertexPos;

// ====== GERSTNER WAVES ======

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
    
    // Aplicar Gerstner waves
    vec4 wave1 = vec4(1.0, 0.0, 0.25, 60.0);
    vec4 wave2 = vec4(0.2, 0.4, 0.15, 31.0);
    vec4 wave3 = vec4(0.5, 0.1, 0.1, 18.0);
    
    pos += gerstnerWave(wave1, pos) * waveAmplitude;
    pos += gerstnerWave(wave2, pos) * waveAmplitude * 0.7;
    pos += gerstnerWave(wave3, pos) * waveAmplitude * 0.5;
    
    // View position
    viewPos = gbufferModelViewMatrix * vec4(pos, 1.0);
    gl_Position = gbufferProjectionMatrix * viewPos;
    
    // Outputs
    texCoord = vaTexCoord + vec2(frameTimeCounter * waveSpeed * 0.05);
    normal = normalize(mat3(gbufferModelViewMatrix) * vaNormal);
    color = vaColor;
    vertexPos = pos;
}
