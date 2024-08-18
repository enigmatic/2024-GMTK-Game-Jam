shader_type canvas_item;
uniform sampler2D grass_noise: repeat_enable;
uniform float speed = .1;

void vertex() {
	// Called for every vertex the material is visible on.
	vec4 new_color = vec4(vec3(0.0),1.0);
	new_color.g = texture(grass_noise, UV).r + 1.;
	
	new_color *= 1.0-UV.y;
	
	COLOR = new_color;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
