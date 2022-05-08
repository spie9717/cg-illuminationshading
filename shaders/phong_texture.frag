#version 300 es

precision mediump float;

in vec3 frag_pos;
in vec3 frag_normal;
in vec2 frag_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n
uniform sampler2D image;          // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
    // Ambient
    vec3 ambient = light_ambient;

    // Diffuse
    vec3 L = normalize(light_position - frag_pos);
    vec3 N = normalize(frag_normal);
    float diffuse_brightness = max(0.0, dot(N, L));
    vec3 diffuse = light_color * diffuse_brightness;

    // Specular
    vec3 R = 2.0 * (dot(N, L)) * N - L;
    vec3 V = normalize(camera_position - frag_pos);
    float specular_intensity = pow(max(dot(R, V), 0.0), material_shininess);
    vec3 specular = specular_intensity * light_color;

    FragColor = vec4(((ambient + diffuse + specular) * material_color), 1.0) * texture(image, frag_texcoord);
}
