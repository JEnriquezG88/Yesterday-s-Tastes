shader_type canvas_item;

uniform sampler2D mask_texture;

uniform vec2 mask_position = vec2(0.5);
uniform vec2 mask_scale = vec2(1.0);

void fragment() {
	vec2 mask_uv = (UV - mask_position) / mask_scale + 0.5;
	
	vec4 mask = texture(mask_texture, mask_uv);
	
	COLOR = vec4(0.0, 0.0, 0.0, 1.0 - mask.a);
}
