shader_type spatial;

render_mode unshaded, cull_disabled;

uniform sampler2D albedo_texture : source_color;

uniform float wind_amplitude = 0.05;
uniform float wind_speed = 1.5;


void vertex() {
	float height = clamp(VERTEX.y / 1.8, 0.0, 1.0);
	
	float bend_angle = sin(TIME * wind_speed) * wind_amplitude;
	
	float angle = bend_angle * height;
	
	vec2 position = VERTEX.xy;
	
	VERTEX.x = position.x * cos(angle) + position.y * sin(angle);
	VERTEX.y = -position.x * sin(angle) + position.y * cos(angle);
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}
