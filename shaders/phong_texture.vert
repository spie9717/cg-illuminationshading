#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;
in vec2 vertex_texcoord;

uniform vec2 texture_scale;
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 frag_pos;
out vec3 frag_normal;
out vec2 frag_texcoord;

void main() {
    mat4 modelViewMatrix = view_matrix * model_matrix;
    frag_pos = (model_matrix * vec4(vertex_position, 1.0)).xyz;

    mat3 normalMatrix = transpose(inverse(mat3(modelViewMatrix)));
    frag_normal = normalize(normalMatrix * vertex_normal);

    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    frag_texcoord = vertex_texcoord * texture_scale;
}
