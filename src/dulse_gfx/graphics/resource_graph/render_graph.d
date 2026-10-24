module dulse_gfx.graphics.resource_graph.render_graph;

import dulse_sdl.graphics;
import dulse_gfx.graphics;
import std.algorithm : all;
import std.typecons : Nullable;

struct RenderGraph
{
	CommandBuffer command_buffer;
	GraphicsPipeline pipeline;
	Texture[string] texture_list;
	TargetInfo[string] target_info_list;

	ref TargetInfo opIndex(in string index) pure nothrow @nogc @safe
	{
		return this.index(index);
	}

	ref typeof(this) render(
		string name,
		void delegate(ref RenderPass) dlg,
	)
	{
		if (index(name).depth_target.isNull)
		{
			command_buffer
				.render(dlg, this.index(name).color_target,);
		}
		else
		{
			command_buffer
				.render(dlg, index(name).color_target, index(name).depth_target.get);
		}
		return this;
	}

protected:
	ref TargetInfo index(in string index) pure nothrow @nogc @safe
	in (index in this.target_info_list)
	{
		return target_info_list[index];
	}
}

struct TargetInfo
{
	GpuColorTargetInfo[] color_target;
	Nullable!GpuDepthStencilTargetInfo depth_target;
}
