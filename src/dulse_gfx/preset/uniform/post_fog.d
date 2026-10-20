module dulse_gfx.preset.uniform.post_fog;

import dulse;

struct UniformPostFog
{
	float fog_start;
	float fog_end;
	align(16) ColorF fog_color;
}
