shader_type canvas_item;
uniform float pixelization =1440;
uniform sampler2D noise: repeat_enable;
void vertex() {
	// Called for every vertex the material is visible on.
}
vec2 pixelizeCoordinates(vec2 coordinates){
	return floor(coordinates * pixelization ) / pixelization;
}
void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, pixelizeCoordinates(UV));
	if (COLOR.a > 0.01)
	{
		COLOR +=  texture(noise, pixelizeCoordinates(UV));
	}

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
