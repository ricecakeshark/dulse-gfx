module dulse_gfx.graphics.command.compute_pass;

import dulse.core.meta;
import dulse_sdl.graphics.command;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource;
import dulse_gfx.graphics.command;
import dulse_gfx.graphics.resource;
import std : array, map;

alias ComputePass = GpuComputePass;
// issue:
// 		dulse_sdl's ComputePass.bind() hide dulse_gfx's ComputePass.bind(),
//		then I forced to rename bind_all() from bind()
ref ComputePass bind_all(TypeSeq...)(return ref ComputePass pass, TypeSeq bindable_list)
{
	GpuTextureSamplerBinding[] sampler_binding;

	static if (contain_type!(GfxComputePipeline, TypeSeq))
	{
		pass.bind(
			cast(GpuComputePipeline)[
				filter_by_type!(GfxComputePipeline, bindable_list)
			][0]
		);
	}
	static if (contain_type!(StorageBuffer, TypeSeq))
	{
		pass.bind(
			0, cast(StorageBuffer[])[
				filter_by_type!(StorageBuffer, bindable_list)
			]
		);
	}
	static if (contain_type!(GfxTexture, TypeSeq))
	{
		sampler_binding ~= (cast(GfxTexture[])[
				filter_by_type!(GfxTexture, bindable_list)
			])
			.map!(elm => elm.binding)
			.array();
	}
	static if (contain_type!(GpuTextureSamplerBinding, TypeSeq))
	{
		sampler_binding ~= (cast(GpuTextureSamplerBinding[])[
				filter_by_type!(GpuTextureSamplerBinding, bindable_list)
			]);
	}
	if (sampler_binding.length > 0)
	{
		pass.bind(0, sampler_binding,);
	}
	return pass;
}
