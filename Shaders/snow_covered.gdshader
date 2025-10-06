shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D snow_texture : source_color;

uniform float snow_amount = 1.0;
uniform float snow_uv_scale = 1.0;
uniform float snow_softness = 10.0;

uniform float specular = 0.0;
uniform float roughness = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 col = texture(albedo_texture, UV).rgb;

	vec3 vs_up = mat3(VIEW_MATRIX) * vec3(0.0, 1.0, 0.0);
	float snow_mask = clamp(dot(NORMAL, vs_up * snow_amount), 0.0, 1.0);
	snow_mask = pow(snow_mask, snow_softness);

	vec3 ws_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec2 ws_uv = ws_pos.xz * snow_uv_scale;

	vec4 snow_col = texture(snow_texture, ws_uv);

	float snow_alpha = snow_col.a;

	vec3 final_color = mix(col, snow_col.rgb, snow_mask);
	final_color = mix(final_color, col, snow_alpha);

	ALBEDO = final_color;
	SPECULAR = specular;
	ROUGHNESS = roughness;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
