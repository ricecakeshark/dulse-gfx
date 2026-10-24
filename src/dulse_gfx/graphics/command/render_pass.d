module dulse_gfx.graphics.command.render_pass;

import dulse_gfx.graphics.command;
import dulse_gfx.graphics.resource;
import dulse_sdl.graphics.desc : GpuTextureSamplerBinding;
import dulse_sdl.graphics.command : GpuRenderPass;
import dulse_sdl.graphics.resource : GpuGraphicsPipeline;
import dulse.core.meta;
import std.algorithm;

alias RenderPass = GfxRenderPass;

struct GfxRenderPass
{
	GpuRenderPass derived;
	uint current_index;

	this(CommandBuffer cb)
	{
		derived = GpuRenderPass(cb);
		return;
	}

	ref typeof(this) bind(TypeList...)(TypeList bindable_list)
	{
		static if (contain_type!(GraphicsPipeline, TypeList))
		{
			this.derived.bind(
				[
					filter_by_type!(GraphicsPipeline, bindable_list)
				][0]
			);
		}
		static if (contain_type!(VertexBuffer, TypeList))
		{
			this.derived.bind(
				[
					filter_by_type!(VertexBuffer, bindable_list)
				],0u
			);
		}
		static if (contain_type!(IndexBuffer, TypeList))
		{
			this.derived.bind(
				[
					filter_by_type!(IndexBuffer, bindable_list)
				][0]
			);
		}
		static if (contain_type!(GpuTextureSamplerBinding, TypeList))
		{
			this.derived.bind(
				[
					filter_by_type!(GpuTextureSamplerBinding, bindable_list)
				]
			);
		}

		return this;
	}

	alias derived this;
}
