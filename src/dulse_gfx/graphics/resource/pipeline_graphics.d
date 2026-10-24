module dulse_gfx.graphics.resource.pipeline_graphics;

import dulse_sdl.graphics;
import dulse_gfx.graphics;

alias GraphicsPipeline = GfxGraphicsPipeline;

class GfxGraphicsPipeline : GpuGraphicsPipeline
{
	GfxGraphicsPipelineCreateInfo create_info;
	GpuVertexShader vertex_shader;
	GpuFragmentShader fragment_shader;

	this(GpuDevice device)
	{
		super(device);
		return;
	}

	this(GraphicsContext context)
	{
		super(context.device);
		return;
	}

	typeof(this) bind(TypeList...)(TypeList list)
	{
		foreach (ref elm; list)
		{
			this.bind(elm);
		}
		return this;
	}

	typeof(this) bind(GfxGraphicsPipelineCreateInfo create_info)
	{
		this.create_info = create_info;
		return this;
	}

	typeof(this) bind(GpuVertexShader vertex_shader)
	{
		create_info.vertex_shader = vertex_shader;
		return this;
	}

	typeof(this) bind(GpuFragmentShader fragment_shader)
	{
		create_info.fragment_shader = fragment_shader;
		return this;
	}

	typeof(this) create()
	in (this.create_info.vertex_shader !is null)
	in (this.create_info.fragment_shader !is null)
	{
		super.create(cast(GpuGraphicsPipelineCreateInfo) create_info);
		return this;
	}

	typeof(this) create(GfxGraphicsPipelineCreateInfo create_info)
	{
		this.create_info = create_info;
		super.create(cast(GpuGraphicsPipelineCreateInfo) create_info);
		return this;
	}
}
