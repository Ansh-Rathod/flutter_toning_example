# Toning_example

Example for the implementing Toning filter on Image using shaders. original copy of the javascript library from https://github.com/PixiColorEffects/pixi-color-effects/blob/main/src/filters/toning/index.ts

### Shader

```
#version 460 core
precision highp float;

#include <flutter/runtime_effect.glsl>
out vec4 FragColor;

uniform sampler2D uSampler;
uniform sampler2D paletteMap;
uniform vec2 uSize;
uniform float value;

float luma(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec2 fragCoord = FlutterFragCoord();
    vec2 uv = fragCoord/uSize;

    lowp vec4 base = texture(uSampler, uv);
    float avg = luma(base.rgb);
    float r = texture(paletteMap, vec2(avg, 0)).r;
    float g = texture(paletteMap, vec2(avg, 0)).g;
    float b = texture(paletteMap, vec2(avg, 0)).b;
    FragColor = mix(base, vec4(r, g, b, base.a), value);
}

```
