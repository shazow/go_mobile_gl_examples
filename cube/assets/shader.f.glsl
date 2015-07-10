#version 100

precision highp float;

uniform mat4 model;
uniform sampler2D tex;

uniform vec3 lightPosition;
uniform vec3 lightIntensities;

varying vec2 fragTexCoord;
varying vec3 fragNormal;
varying vec3 fragCoord;



mat3 transpose(mat3 m) {
    return mat3(
        m[0][0], m[1][0], m[2][0],
        m[0][1], m[1][1], m[2][1],
        m[0][2], m[1][2], m[2][2]
        );
}


float determinant(mat3 m) {
    return m[0][0]*( m[1][1]*m[2][2] - m[2][1]*m[1][2])
         - m[1][0]*( m[0][1]*m[2][2] - m[2][1]*m[0][2])
         + m[2][0]*( m[0][1]*m[1][2] - m[1][1]*m[0][2]);
}

mat3 inverse(mat3 m) {
    float d = 1.0 / determinant(m) ;
    return d * mat3(
        m[2][2]*m[1][1] - m[1][2]*m[2][1],
        m[1][2]*m[2][0] - m[2][2]*m[1][0],
        m[2][1]*m[1][0] - m[1][1]*m[2][0],

        m[0][2]*m[2][1] - m[2][2]*m[0][1],
        m[2][2]*m[0][0] - m[0][2]*m[2][0],
        m[0][1]*m[2][0] - m[2][1]*m[0][0],

        m[1][2]*m[0][1] - m[0][2]*m[1][1],
        m[0][2]*m[1][0] - m[1][2]*m[0][0],
        m[1][1]*m[0][0] - m[0][1]*m[1][0]
        );
}

void main() {
    // Calculate normal in world coordinates
    mat3 normalMatrix = transpose(inverse(mat3(model)));
    vec3 normal = normalize(normalMatrix * fragNormal);

    // Calculate the location of this fragment (pixel) in world coordinates
    vec3 fragPosition = vec3(model * vec4(fragCoord, 1));

    // Calculate the vector from this pixels surface to the light source
    vec3 surfaceToLight = lightPosition - fragPosition;

    // Calculate the cosine of the angle of incidence
    float brightness = dot(normal, surfaceToLight) / (length(surfaceToLight) * length(normal));
    brightness = clamp(brightness, 0.0, 1.0);

    vec4 surfaceColor = texture2D(tex, fragTexCoord);
    gl_FragColor = vec4(brightness * lightIntensities * surfaceColor.rgb, surfaceColor.a);
}
