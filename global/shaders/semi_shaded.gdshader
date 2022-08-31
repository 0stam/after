shader_type spatial;

void fragment() {
	ALBEDO = vec3(0.02);
}

void light() {
	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.3, 0.6) * ATTENUATION;
}
