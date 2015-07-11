#version 100

precision mediump float;

uniform mat4 model;
uniform sampler2D tex;

uniform vec3 lightPosition;
uniform vec3 lightIntensities;

varying vec2 fragTexCoord;
varying vec3 fragNormal;
varying vec3 fragCoord;

const int mode = 1;
const vec3 diffuseColor = vec3(0.5, 0.0, 0.0);
const float shininess = 16.0;
const float screenGamma = 2.2; // Assume the monitor is calibrated to the sRGB color space

void main() {
    vec3 normal = normalize(fragNormal);
    vec3 lightDir = normalize(lightPosition - fragCoord);

    float lambertian = max(dot(lightDir,normal), 0.0);
    float specular = 0.0;

    if (lambertian > 0.0) {
        vec3 viewDir = normalize(-fragCoord);
        vec3 halfDir = normalize(lightDir + viewDir);
        float specAngle = max(dot(halfDir, normal), 0.0);
        specular = pow(specAngle, shininess);
    }

    vec4 surfaceColor = texture2D(tex, fragTexCoord);
    vec3 colorLinear = surfaceColor.rgb + lambertian * diffuseColor + specular * lightIntensities;

    // apply gamma correction (assume ambientColor, diffuseColor and lightIntensities
    // have been linearized, i.e. have no gamma correction in them)
    vec3 colorGammaCorrected = pow(colorLinear, vec3(1.0/screenGamma));

    // use the gamma corrected color in the fragment
    gl_FragColor = vec4(colorGammaCorrected, surfaceColor.a);
}
