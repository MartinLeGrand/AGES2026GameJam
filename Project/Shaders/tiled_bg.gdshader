shader_type canvas_item;

uniform sampler2D checkerboard_texture : source_color, filter_nearest, repeat_enable;
uniform float offset;
uniform vec4 background_color : source_color;

void fragment() {
	COLOR = background_color * texture(checkerboard_texture, offset - UV * 0.05);
}