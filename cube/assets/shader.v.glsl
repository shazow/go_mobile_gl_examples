#version 100

uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

attribute vec3 vertCoord;
attribute vec2 vertTexCoord;
attribute vec3 vertNormal;

varying vec3 fragCoord;
varying vec2 fragTexCoord;
varying vec3 fragNormal;

void main() {
    fragCoord = vertCoord;
    fragTexCoord = vertTexCoord;
    fragNormal = vertNormal;

    gl_Position = projection * view * model * vec4(vertCoord, 1);
}
