shader_type canvas_item;

uniform float limit: hint_range(0.0,1.0) = 0.2;
uniform float blur: hint_range(0.0,1.0, 0.01) = 0.1;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 tint_color : source_color;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = UV - center;
    float radius = length(uv);
    if (radius < limit) {
        float blur_amount = clamp(blur * 10.0, 0.0, 6);        
        COLOR = textureLod(screen_texture, SCREEN_UV, blur_amount);
    } else {
        COLOR.a = 0.0;
    }
}