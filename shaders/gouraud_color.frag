#version 300 es

precision mediump float;

in vec3 ambient;
in vec3 diffuse;
in vec3 specular;
in vec3 world_vertex_normal;

uniform vec3 material_color;    // Ka and Kd
uniform vec3 material_specular; // Ks

out vec4 FragColor;

void main() {
    FragColor = vec4(((ambient + diffuse + specular) * material_color), 1.0);
    //FragColor = vec4(world_vertex_normal, 1.0);
}
