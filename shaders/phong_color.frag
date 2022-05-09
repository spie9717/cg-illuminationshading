#version 300 es

precision mediump float;

in vec3 frag_pos;
in vec3 frag_normal;

uniform vec3 light_ambient;
uniform int light_count;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n

out vec4 FragColor;

void main() {
    
    vec3 diffuse = vec3(0,0,0);
    vec3 specular = vec3(0,0,0);
    
    // Ambient
    vec3 ambient = light_ambient;

    for(int i = 0; i < light_count; i++) {
        // Diffuse
        vec3 L = normalize(light_position[i] - frag_pos);
        vec3 N = normalize(frag_normal);
        float diffuse_brightness = max(0.0, dot(N, L));
        diffuse = diffuse + (light_color[i] * diffuse_brightness);

        // Specular
        vec3 R = 2.0 * (dot(N, L)) * N - L;
        vec3 V = normalize(camera_position - frag_pos);
        float specular_intensity = pow(max(dot(R, V), 0.0), material_shininess);
        specular = specular + (specular_intensity * light_color[i]);
    }
    
    specular = clamp(specular, 0.0, 1.0);
    diffuse = clamp(diffuse, 0.0, 1.0);

    FragColor = vec4(((((ambient + diffuse) * material_color) + (specular * material_specular))), 1.0);
}
