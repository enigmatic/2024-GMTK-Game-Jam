shader_type canvas_item;


uniform float pixelization = 32;
uniform float width=32;
uniform float height = 5;
uniform float bottom_radius = 5;
uniform sampler2D base_noise;
uniform float color_steps = 4;

void vertex() {
	// Called for every vertex the material is visible on.
}
vec2 pixelizeCoordinates(vec2 coordinates)
{
	return floor(coordinates * pixelization) / pixelization;
}

float step_color_channel(float color_amount)
{
	return floor(color_amount * color_steps)/color_steps;
}
vec3 step_color_channels(vec3 color_amounts)
{
	return floor(color_amounts * color_steps)/color_steps;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 final_color = vec4(0.0);
	vec2 UVPix = pixelizeCoordinates(UV);
	float w = (width+pixelization)/pixelization*.5;
	if(UVPix.x > (.99-w)- .1*UV.y && UVPix.x < w + .1* UV.y){
		final_color.rgb += step_color_channels(texture(base_noise,UVPix).rgb);
		final_color.a = 1.0;
	}
	COLOR = final_color;
	
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
