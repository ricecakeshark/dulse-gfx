module kelp_gfx.graphics.pipeline;

import kelp_sdl.graphics;

struct GfxGraphicsPipeline
{
	GpuGraphicsPipeline graphics_pipeline;
	GpuVertexShader vertex_shader;
	GpuFragmentShader fragment_shader;

	typeof(this) bind(GpuGraphicsPipeline pipeline)
	{
		this.graphics_pipeline = pipeline;
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

	typeof(this) create(GpuGraphicsPipelineCreateInfo pipeline_create_info)
	in (this.vertex_shader !is null)
	in (this.fragment_shader !is null)
	{
		pipeline_create_info.vertex_shader = this.vertex_shader.handle;
		pipeline_create_info.fragment_shader = this.fragment_shader.handle;
		graphics_pipeline.create(pipeline_create_info);
		return this;
	}
}