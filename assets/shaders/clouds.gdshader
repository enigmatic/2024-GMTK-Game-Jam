shader_type canvas_item;

uniform sampler2D clouds: repeat_enable;
uniform sampler2D clouds2: repeat_enable;
uniform vec2 cloud_speed = vec2(.01,0);


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex = texture(clouds,UV+TIME*cloud_speed);
	vec4 tex2 = texture(clouds2,UV+TIME*cloud_speed*.25);
	COLOR = vec4(1.0,1.0,1.0,0.0);
	COLOR.a = tex.r + tex2.r-0.90;

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
