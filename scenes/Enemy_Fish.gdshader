shader_type canvas_item;

uniform float rate = 2.5;
uniform float factor = 0.025;

void fragment(){
	vec2 distortedUV = (UV - 0.025) * 1.05;
	distortedUV.x -= sin(distortedUV.y * 7.0 + TIME*rate) * factor;
	distortedUV.y -= sin(distortedUV.x * 3.0 + TIME*rate) * factor;
	COLOR = texture(TEXTURE, distortedUV);
}