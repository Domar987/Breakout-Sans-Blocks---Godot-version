shader_type canvas_item;

instance uniform vec4 currentdark;

void fragment() {
	vec4 asd = currentdark;
	asd.w = COLOR.w;
	COLOR = mix(COLOR,asd,0.5);
}