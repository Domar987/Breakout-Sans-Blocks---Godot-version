shader_type canvas_item;

uniform sampler2D screenshot : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D parenttexture;

void fragment() {
	COLOR = vec4(texture(screenshot,SCREEN_UV).rgb,texture(TEXTURE,UV).a);
	COLOR = vec4(COLOR.r * 1.5,COLOR.g * 1.5,COLOR.b * 1.5,COLOR.a);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
