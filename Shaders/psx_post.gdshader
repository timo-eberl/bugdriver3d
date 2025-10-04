shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	vec3 s = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 c = pow(s, vec3(1.0/2.2)); // linear to srgb
	c = clamp(round(c * 31.0), vec3(0), vec3(31));
	c /= 31.0; // back to 0-1
	c = pow(c, vec3(2.2)); // srgb to linear
	
	COLOR.rgb = c;
}