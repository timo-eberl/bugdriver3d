// NOTE: Shader automatically converted from Godot Engine 4.5.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;
render_mode skip_vertex_transform;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo_fill : source_color, filter_nearest_mipmap, repeat_disable;
uniform sampler2D texture_albedo : source_color, filter_nearest_mipmap, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_nearest_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_nearest_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float top_bounds = 1.0;
uniform float bottom_bounds = -1.0;
uniform float fill : hint_range(0.0, 1.0);

float inv_lerp(float a, float b, float x) { return (x - a) / (b - a); }

void vertex() {
	float height = inv_lerp(bottom_bounds, top_bounds, VERTEX.y);
	bool above = height > fill;
	if (above) {
		VERTEX.y = mix(bottom_bounds, top_bounds, fill);
	}
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// it would be technically correct to do this, but if we dont then it looks like the lighting is baked
	//NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	vec4 albedo_tex_fill = texture(texture_albedo_fill, vec2(fill, 0.0));
	ALBEDO = albedo.rgb * albedo_tex.rgb * albedo_tex_fill.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;

	if (fill == 0.0) discard;
}
