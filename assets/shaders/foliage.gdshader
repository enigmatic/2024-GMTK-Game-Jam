shader_type canvas_item;

uniform sampler2D green_noise;
uniform float skew_x: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float skew_y: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float pixelization = 32;
uniform float radius = 32;
uniform float base_color_amount = .25;
uniform vec4 outline_color: source_color = vec4(0.0,.25,0.0,1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}
vec2 pixelizeCoordinates(vec2 coordinates)
{

	return floor(coordinates * pixelization ) / pixelization;
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 final_color = vec4(0.0);
	vec2 UVPix = pixelizeCoordinates(UV);
	final_color.g = texture(green_noise,UVPix).r + base_color_amount;
	float r = (radius)/pixelization*.5;
	if(distance(vec2(.5,.5),UVPix) < r){
		final_color.a = 1.0;
	}
	 if(distance(vec2(.5,.5),UVPix) > r && distance(vec2(.5,.5),UVPix) < r*1.1){
		final_color = outline_color;
	}
	COLOR = final_color;
	
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
