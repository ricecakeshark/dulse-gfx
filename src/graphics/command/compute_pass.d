module dulse_gfx.graphics.command.compute_pass;

import dulse.core.meta;
import dulse_sdl.graphics.command;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource;
import dulse_gfx.graphics.command;
import dulse_gfx.graphics.resource;
import std : array, map;

alias ComputePass = GfxComputePass;

struct GfxComputePass
{
	GpuComputePass derived;

	this(CommandBuffer cb)
	{
		derived = GpuComputePass(cb);
		return;
	}

	ref typeof(this) bind(TypeSeq...)(TypeSeq bindable_list)
	{
		static if (contain_type!(ComputePipeline, TypeSeq))
		{
			this.derived.bind(cast(GpuComputePipeline)[
				filter_by_type!(ComputePipeline, bindable_list)
			][0]);
		}
		static if (contain_type!(StorageBuffer, TypeSeq))
		{
			this.derived.bind(cast(GpuStorageBuffer[])[
				filter_by_type!(StorageBuffer, bindable_list)
			],);
		}

		scope GpuTextureSamplerBinding[] binding;

		static if (contain_type!(GfxTexture, TypeSeq))
		{
			binding ~= (cast(GfxTexture[])[filter_by_type!(GfxTexture, bindable_list)])
				.map!(elm => elm.binding)
				.array();
		}
		static if (contain_type!(GpuTextureSamplerBinding, TypeSeq))
		{
			binding ~= (cast(GpuTextureSamplerBinding[])[
				filter_by_type!(GpuTextureSamplerBinding, bindable_list)
			]);
		}
		static if (
			contain_type!(GfxTexture, TypeSeq)
			|| contain_type!(GpuTextureSamplerBinding, TypeSeq)
			)
		{
			this.derived.bind(binding,);
		}
		return this;
	}

	alias derived this;
}
