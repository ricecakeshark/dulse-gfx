module dulse_gfx.graphics.resource.pipeline_graphics;

import dulse_sdl.graphics;
import dulse_gfx.graphics;

alias GraphicsPipeline = GpuGraphicsPipeline;

class GfxGraphicsPipeline : GpuGraphicsPipeline
{
	GpuGraphicsPipelineCreateInfo create_info;
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

	typeof(this) bind(GpuGraphicsPipelineCreateInfo create_info)
	{
		this.create_info = create_info;
		return this;
	}

	typeof(this) bind(GpuVertexShader vertex_shader)
	{
		this.vertex_shader = vertex_shader;
		return this;
	}

	typeof(this) bind(GpuFragmentShader fragment_shader)
	{
		this.fragment_shader = fragment_shader;
		return this;
	}

	typeof(this) create()
	in (this.vertex_shader !is null)
	in (this.fragment_shader !is null)
	{
		create_info.vertex_shader = cast() this.vertex_shader.handle;
		create_info.fragment_shader = cast() this.fragment_shader.handle;
		super.create(create_info);
		return this;
	}
}
