#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;
in vec2 vertex_texcoord;

uniform vec3 light_ambient;
uniform int light_count;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
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
    vec3 nN = normalize(normalMatrix * vertex_normal);
    diffuse = vec3(0.0, 0.0, 0.0);

    // Specular
    vec3 nV = normalize(camera_position - world_vertex_position);
    specular = vec3(0.0, 0.0, 0.0);
    
    // Iterate over lights
    for(int i=0;i<light_count;i++) {

        vec3 nL = normalize(light_position[i] - world_vertex_position);

        // Diffuse
        float diffuse_intensity = clamp(dot(nN, nL), 0.0, 1.0);
        diffuse = diffuse + (diffuse_intensity * light_color[i]);

        // Specular
        vec3 nR = 2.0 * (dot(nN, nL)) * nN - nL;
        float specular_intensity = pow(clamp(dot(nR, nV), 0.0, 1.0), material_shininess);
        specular = specular + (specular_intensity * light_color[i]);

    }
    specular = clamp(specular, 0.0, 1.0);
    diffuse = clamp(diffuse, 0.0, 1.0);

    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    frag_texcoord = vertex_texcoord * texture_scale;
}
