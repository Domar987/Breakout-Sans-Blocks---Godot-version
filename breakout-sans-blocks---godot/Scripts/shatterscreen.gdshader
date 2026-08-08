shader_type canvas_item;

uniform sampler2D screenshot : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 initialposition;
uniform float zoom;

void fragment() {
	vec2 topleftcorner = initialposition - 0.5 * zoom/TEXTURE_PIXEL_SIZE;
	vec2 toprightcorner = initialposition + 0.5 * zoom/TEXTURE_PIXEL_SIZE;
	vec4 points = vec4( (0.5/SCREEN_PIXEL_SIZE + topleftcorner)/(1.0/SCREEN_PIXEL_SIZE),
						(0.5/SCREEN_PIXEL_SIZE + toprightcorner)/(1.0/SCREEN_PIXEL_SIZE));
	vec2 lerped = vec2(mix(points.r,points.b,UV.x),mix(points.g,points.a,UV.y));
	COLOR = vec4(texture(screenshot,lerped).rgb,texture(TEXTURE,UV).a);
	COLOR = vec4(COLOR.r * 1.5,COLOR.g * 1.5,COLOR.b * 1.5,COLOR.a);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
