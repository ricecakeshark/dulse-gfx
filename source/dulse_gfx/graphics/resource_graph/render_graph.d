module dulse_gfx.graphics.resource_graph.render_graph;

import dulse_sdl.graphics;
import dulse_gfx.graphics;
import std.algorithm : all;

class GfxRenderGraph
{
	GpuCommandBuffer command_buffer;
	GpuSwapchainTexture swapchain_texture;
	GfxRenderPass[string] pass_list;
	GfxRenderPipeline[string] pipeline_list;
	GfxTexture[string] texture_list;

	this(GfxGraphicsContext context)
	{
		context.create(
			this.command_buffer,
			this.swapchain_texture,
		);
		return;
	}

	bool has_pass(string[] id_list...) const pure nothrow @nogc @safe
	{
		return id_list.all!(id => (id in this.pass_list) !is null);
	}

	bool has_pipeline(string[] id_list...) const pure nothrow @nogc @safe
	{
		return id_list.all!(id => (id in this.pipeline_list) !is null);
	}

	bool has_texture(string[] id_list...) const pure nothrow @nogc @safe
	{
		return id_list.all!(id => (id in this.texture_list) !is null);
	}

	GfxRenderPipeline pipeline(string pipeline_id)
	in (pipeline_id in this.pipeline_list)
	{
		return this.pipeline_list[pipeline_id];
	}

	typeof(this) register(TypeList...)(TypeList register_list)
	{
		foreach (registree; register_list)
		{
			this.register(registree);
		}
		return this;
	}

	typeof(this) register(ref GfxRenderPipeline pipeline)
	{
		this.pipeline_list[pipeline.id] = pipeline;
		return this;
	}

	typeof(this) register(string id, ref GpuTexture texture)
	{
		this.texture_list[id] = GfxTexture(texture);
		return this;
	}

	typeof(this) append(
		ref GfxRenderPass pass
	)
	{
		this.pass_list[pass.id] = pass;
		return this;
	}

	typeof(this) execute()
	in
	{
		assert(command_buffer !is null);
		assert(swapchain_texture !is null);
	}
	do
	{
		command_buffer.acquire_buffer()
			.acquire_texture(swapchain_texture);
		if (swapchain_texture !is null)
		{
			foreach (pass; this.pass_list)
			{
				pass.publish(this);
			}
		}
		command_buffer.submit();
		return this;
	}
}

struct GfxRenderPass
{
	string id;

	string render_pipeline;
	string[] read_texture;
	string[] write_texture;

	ref typeof(this) bind(GfxRenderGraph graph)
	{
		/+graph.command_buffer.render(
			(pass) { pass.bind(graph.pipeline(this.render_pipeline)); return; }
		);+/
		return this;
	}

	void publish(GfxRenderGraph graph)
	{
		graph.has_pipeline(this.render_pipeline);
		graph.has_texture(this.read_texture);
		graph.has_texture(this.write_texture);
		return;
	}
}

struct GfxComputePass
{
	string name;

	string compute_pipeline;
	string[] read_texture;
	string[] write_texture;

	ref typeof(this) bind(GfxRenderGraph graph)
	{
		//graph.command_buffer.bind(graph.pipeline_list[this.compute_pipeline]);
		return this;
	}

	void publish(GfxRenderGraph graph)
	{
		graph.has_pipeline(this.compute_pipeline);
		graph.has_texture(this.read_texture);
		graph.has_texture(this.write_texture);
		return;
	}
}

struct GfxRenderPipeline
{
	GpuGraphicsPipeline pipeline;
	string id;
}

struct GfxComputePipeline
{
	GpuComputePipeline pipeline;
	string id;
}

struct GfxTexture
{
	GpuAbstractTexture texture_ref;
	GfxTextureDesc texture_desc;
}

struct GfxTextureDesc
{
	GpuTextureFormat format;
}
