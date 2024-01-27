shader_type canvas_item;
render_mode unshaded;

uniform sampler2D rain_texture : repeat_enable, filter_linear_mipmap;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	// Called for every pixel the material is visible on.
	//COLOR.a *= texture(mask, SCREEN_UV).a;
	//COLOR = vec4(textureLod(screen_texture, SCREEN_UV, 0.0).rgb*0.5,1);
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 uv = UV;
	uv.y -= TIME*.25;
	COLOR = textureLod(rain_texture, uv, 0.0);
	COLOR.a *= 1.0-c.a;
}

