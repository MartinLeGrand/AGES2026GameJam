shader_type spatial;
render_mode unshaded;

uniform vec4 albedo_color : source_color = vec4(1.0); // Custom albedo

// linear to sRGB if output is linear.

void fragment() {
	vec3 c = COLOR.rgb; // NOTE: this is always linear
	if (OUTPUT_IS_SRGB) { // If Godot hasn't converted to sRGB, do it
		c = mix(1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055,
		        c * 12.92,
		        lessThan(c, vec3(0.0031308)));
	}
	ALBEDO = c * albedo_color.rgb; 
}