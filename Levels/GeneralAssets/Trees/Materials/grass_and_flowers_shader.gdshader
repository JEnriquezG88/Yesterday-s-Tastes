shader_type spatial;

render_mode unshaded, cull_disabled;

uniform sampler2D albedo_texture : source_color;

uniform float wind_amplitude = 0.15;
uniform float wind_speed = 1.5;
uniform float wind_frequency = 4.0;


void vertex() {
	float height = clamp(VERTEX.y / 0.6, 0.0, 1.0);

	float phase = VERTEX.x * wind_frequency;
	
	float sway = sin(TIME * wind_speed + phase) * wind_amplitude;

	VERTEX.x += sway * height;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
