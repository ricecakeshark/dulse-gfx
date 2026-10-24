module dulse_gfx.graphics.resource.pipeline_compute;

import dulse_gfx.graphics.graphics_context;
import dulse_gfx.graphics.desc;
import dulse_sdl.graphics.desc;
import dulse_sdl.graphics.resource : GpuComputePipeline;

alias ComputePipeline = GfxComputePipeline;

class GfxComputePipeline : GpuComputePipeline
{
	protected GfxComputePipelineCreateInfo _create_info;

	this(GraphicsContext gc)
	{
		super(gc.device);
		return;
	}

	@property ref GfxComputePipelineCreateInfo create_info() pure nothrow @nogc @safe
	{
		return this._create_info;
	}

	typeof(this) bind(GfxComputePipelineCreateInfo info)
	{
		this._create_info = info;
		return this;
	}

	typeof(this) create()
	{
		super.create(cast(GpuComputePipelineCreateInfo) this._create_info);
		return this;
	}
}
