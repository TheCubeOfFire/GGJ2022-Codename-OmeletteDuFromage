shader_type spatial;
render_mode unshaded;

uniform float u_noise_size = 1.;
uniform float u_time_scale = 1.;

uniform vec3 u_background_color = vec3(0., 0., 0.);
uniform vec3 u_foreground_color = vec3(1., 0., 0.);

uniform float u_bg_threshold = .4;

varying vec3 v_world_vertex;

vec4 hash44(vec4 p4)
{
    p4 = fract(p4  * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy+33.33);
    return fract((p4.xxyz+p4.yzzw)*p4.zywx);
}

float noise4(in vec4 grid_coord) {
    vec4 cell_coord = fract(grid_coord);
    vec4 cell_index = floor(grid_coord);

    float min_dist = 1.;

    for (int w = -1; w <= 1; ++w) {
        for (int z = -1; z <= 1; ++z) {
            for (int y = -1; y <= 1; ++y) {
                for (int x = -1; x <= 1; ++x) {
                    vec4 neighbor = vec4(float(x), float(y), float(z), float(w));
                    vec4 point = hash44(cell_index + neighbor);
                    vec4 diff = neighbor + point - cell_coord;
                    float dist = length(diff);
                    min_dist = min(min_dist, dist);
                }
            }
        }
    }

    return min_dist;
}

float fbm4(in vec4 st) {
    const int octaves = 4;

    float value = 0.0;
    float amplitude = .5;
    float frequency = 0.;

    for (int i = 0; i < octaves; i++) {
        float n = noise4(st);
        value += amplitude * (1. - n * n);
        st *= 2.;
        amplitude *= .5;
    }

    return value;
}

void vertex() {
    v_world_vertex = (WORLD_MATRIX * vec4(VERTEX, 1.)).xyz;
}

void fragment() {
    float noise_result = fbm4(vec4(v_world_vertex / u_noise_size, TIME / u_time_scale));

    ALBEDO = mix(
        u_background_color,
        u_foreground_color,
        smoothstep(u_bg_threshold, 1., 1. - noise_result)
    );
}
