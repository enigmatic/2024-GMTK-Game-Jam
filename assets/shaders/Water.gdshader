shader_type canvas_item;

uniform sampler2D water_noise:repeat_enable;
uniform vec2 offset1 = vec2(0.01f,0.0f);
uniform float speed = .2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 noise_color1 = texture(water_noise,UV + offset1*TIME*speed);
	COLOR = texture(TEXTURE, UV+ noise_color1.r);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
