shader_type canvas_item;

uniform sampler2D water_noise:repeat_enable;
uniform vec2 offset1 = vec2(0.1f,0.0f);
uniform float speed = .2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float d = distance(vec2(.5,.5),UV);
	vec4 noise_color1 = texture(water_noise,UV + offset1*TIME*speed);
	COLOR = texture(water_noise, UV+ noise_color1.r);
	COLOR.a = 2.0 -  d/.2;
}
