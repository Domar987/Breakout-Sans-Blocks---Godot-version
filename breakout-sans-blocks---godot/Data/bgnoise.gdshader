shader_type canvas_item;

uniform sampler2D screenshot:hint_screen_texture;
uniform sampler2D noisetex:hint_default_white, repeat_enable, filter_nearest;
uniform vec4 regularcolors[4];
uniform vec4 darkcolors[4];
uniform vec4 darkercolors[4];
instance uniform float yValue = 0.0;

void fragment() {
	vec4 pixel = texture(screenshot,SCREEN_UV);
	vec4 noise = texture(noisetex,vec2(UV.x,UV.y - yValue/1080.0));
	int curr = 0;
	if(noise.r > 0.5){noise = pixel;}
	else{
		for(int i = 0;i<4;i++){
			if(pixel.r - regularcolors[i].r < 0.001
			   && pixel.g - regularcolors[i].g < 0.001
			   && pixel.b - regularcolors[i].b < 0.001){
				curr = i;
			}
		}
		if(noise.r > 0.3){noise = darkcolors[curr];}
		else{noise = darkercolors[curr];}
	}
	COLOR = mix(noise,darkercolors[curr],0.5);
	//COLOR = texture(noisetex,UV);
}