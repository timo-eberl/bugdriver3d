shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 color_tint : source_color;

void fragment() {
	vec3 s = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	COLOR.rgb = s * color_tint;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
