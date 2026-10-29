module dulse_gfx.graphics.resource.sampler;

import dulse_sdl.graphics.resource.texture;
import dulse_gfx.graphics.resource.texture;

alias Sampler = GpuSampler;

ref GpuSampler set_to(ref GpuSampler sampler, GfxTexture[] texture_list...)
in (sampler !is null, "sampler is null")
{
	foreach (ref texture; texture_list)
	{
		texture.set(sampler);
	}
	return sampler;
}
