// Placeholder terrain look: grass on flat ground, rock on slopes, by world normal.
shader_type spatial;

uniform vec3 grass_color : source_color = vec3(0.30, 0.45, 0.18);
uniform vec3 rock_color : source_color = vec3(0.42, 0.38, 0.33);
uniform float slope_start : hint_range(0.0, 1.0) = 0.65;
uniform float slope_end : hint_range(0.0, 1.0) = 0.85;

varying vec3 v_world_normal;

void vertex() {
	v_world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	float flatness = smoothstep(slope_start, slope_end, v_world_normal.y);
	ALBEDO = mix(rock_color, grass_color, flatness);
	ROUGHNESS = 0.95;
}
