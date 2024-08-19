shader_type canvas_item;

uniform sampler2D rock_noise: repeat_enable;
uniform float speed = 1;
uniform bool pushed = false;
uniform float pixelization = 64.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 pixelizeCoordinates(vec2 coordinates)
{
	return floor(coordinates * pixelization ) / pixelization;
}


void fragment() {
	vec4 white = vec4(vec3(1.),0.0);
	vec2 UVPix = pixelizeCoordinates(UV);
	vec4 final_color  = texture(rock_noise, UV);
	if (sin(TIME*speed) > 0.5 && !pushed) {
		final_color.r +=  sin(TIME*speed)-.5;
	}
	COLOR = final_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
