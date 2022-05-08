#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;
in vec2 vertex_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform float material_shininess;
uniform vec2 texture_scale;
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;
out vec2 frag_texcoord;

void main() {
    mat4 modelViewMatrix = view_matrix * model_matrix;
    mat3 normalMatrix = transpose(inverse(mat3(modelViewMatrix)));

    // Ambient
    ambient = light_ambient;

    // Diffuse
    vec3 world_vertex_position = (model_matrix * vec4(vertex_position, 1.0)).xyz;
    vec3 nL = normalize(light_position - world_vertex_position);
    vec3 nN = normalize(normalMatrix * vertex_normal);
    float diffuse_brightness = max(0.0, dot(nN, nL));
    diffuse = light_color * diffuse_brightness;

    // Specular
    vec3 nR = 2.0 * (dot(nN, nL)) * nN - nL;
    vec3 nV = normalize(camera_position - world_vertex_position);
    float specular_intensity = pow(max(dot(nR, nV), 0.0), material_shininess);
    specular = specular_intensity * light_color;

    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    frag_texcoord = vertex_texcoord * texture_scale;
}
