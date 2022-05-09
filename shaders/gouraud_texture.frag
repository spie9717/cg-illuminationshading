#version 300 es

precision mediump float;

in vec3 ambient;
in vec3 diffuse;
in vec3 specular;
in vec2 frag_texcoord;

uniform vec3 material_color;    // Ka and Kd
uniform vec3 material_specular; // Ks
uniform sampler2D image;        // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
    vec4 tex_color = texture(image, mod(frag_texcoord, 1.0));
    FragColor = vec4(((((ambient + diffuse) * material_color) + (specular * material_specular))), 1.0) * tex_color;
}
