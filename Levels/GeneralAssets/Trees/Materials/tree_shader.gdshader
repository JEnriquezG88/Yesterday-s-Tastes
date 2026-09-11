shader_type spatial;

render_mode unshaded, cull_disabled;

uniform sampler2D albedo_texture : source_color;

uniform float wind_amplitude = 0.08;
uniform float wind_frecuency = 2.0;

void vertex() {
	float leaf_mask = smoothstep(0.65, 0.45, UV.y);
	
	float speed = mix(2.0, 0.7, UV.x);
	
	float phase = UV.x * 2.0;
	
	float sway = sin(TIME * speed + phase) * wind_amplitude;
	
	VERTEX.x += sway * leaf_mask;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	
	ALPHA_SCISSOR_THRESHOLD = 0.5;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
