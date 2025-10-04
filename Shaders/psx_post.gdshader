shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform uint quantization = 15;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	int ps1_dither_matrix[16] = {
		-4, 0, -3, 1,
		2, -2, 3, -1,
		-3, 1, -4, 0,
		3, -1, 2, -2
	};
	float noise = float(ps1_dither_matrix[(int(FRAGCOORD.x) % 4) + (int(FRAGCOORD.y) % 4) * 4]);
	
	vec3 s = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	vec3 c = pow(s, vec3(1.0/2.2)); // linear to srgb
	c = c * 255.0 + noise; // 0-255 and add dither
	c /= 255.0; // 0-1
	c = clamp(round(c * float(quantization)), vec3(0), vec3(float(quantization))); // quantization
	c /= float(quantization); // back to 0-1
	c = pow(c, vec3(2.2)); // srgb to linear
	
	COLOR.rgb = c;
}