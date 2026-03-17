module kelp_gfx.graphics_context;

import bindbc.sdl;
import kelp_sdl;
import kelp_gfx;
import std.format : format;

class GfxGraphicsContext
{
	public GpuDevice device;
	public GpuWindow window;

	protected GpuGraphicsPipeline[] graphics_pipeline_list;
	protected GpuComputePipeline[] compute_pipeline_list;
	protected GpuVertexShader[] vertex_shader_list;
	protected GpuFragmentShader[] fragment_shader_list;
	protected GpuVertexBuffer[] vertex_buffer_list;
	protected GpuIndexBuffer[] index_buffer_list;
	protected GpuDrawBuffer[] draw_buffer_list;
	protected GpuTexture[] texture_list;
	protected GpuSampler[] sampler_list;

	this()
	{

		return;
	}

	~this()
	{
		this.release_all();
		this.release();
		return;
	}

	typeof(this) initialize(in GpuBackend backend = GpuBackend.none)
	{
		this.device = new GpuDevice();
		this.device.create(backend);
		this.window = new GpuWindow();
		this.window.create(960, 540, "");
		this.device.claim(this.window);
		debug
		{
			import std.stdio;

			this.output_driver_list().writeln();
			this.output_shader_format().writeln();
		}
		return this;
	}

	typeof(this) release()
	{
		if (this.window !is null && this.device !is null)
		{
			this.device.release_window(this.window);
		}
		if (this.window !is null)
		{
			this.window.release();
			this.window = null;
		}
		if (this.device !is null)
		{
			this.device.release();
			this.device = null;
		}
		return this;
	}

	typeof(this) release_all()
	{
		this.release_vertex_shader();
		this.release_fragment_shader();
		this.release_graphics_pipeline();
		this.release_vertex_buffer();
		this.release_index_buffer();
		this.release_texture();
		this.release_sampler();
		return this;
	}

	typeof(this) release_all_shader()
	{
		this.release_vertex_shader();
		this.release_fragment_shader();
		return this;
	}

	typeof(this) release_all_buffer()
	{
		this.release_vertex_buffer();
		this.release_index_buffer();
		return this;
	}

	typeof(this) register(GpuComputePipeline pipeline)
	{
		this.compute_pipeline_list ~= pipeline;
		return this;
	}

	typeof(this) create(out GpuCommandBuffer command_buffer)
	{
		command_buffer = new GpuCommandBuffer(this.device, this.window);
		return this;
	}

	typeof(this) create(out GpuSwapchainTexture swapchain_texture)
	{
		swapchain_texture = new GpuSwapchainTexture(this.device, this.window);
		return this;
	}

	GpuVertexShader create_vertex_shader()
	{
		GpuVertexShader temp;
		temp = new GpuVertexShader(this.device);
		this.vertex_shader_list ~= temp;
		return temp;
	}

	typeof(this) release_vertex_shader()
	{
		foreach (index; 0 .. vertex_shader_list.length)
		{
			if (vertex_shader_list[index] is null)
			{
				continue;
			}
			vertex_shader_list[index].release();
			destroy(vertex_shader_list[index]);
		}
		vertex_shader_list = [];
		return this;
	}

	GpuFragmentShader create_fragment_shader()
	{
		GpuFragmentShader temp;
		temp = new GpuFragmentShader(this.device);
		this.fragment_shader_list ~= temp;
		return temp;
	}

	typeof(this) release_fragment_shader()
	{
		foreach (index; 0 .. fragment_shader_list.length)
		{
			if (fragment_shader_list[index] is null)
			{
				continue;
			}
			fragment_shader_list[index].release();
			destroy(fragment_shader_list[index]);
		}
		fragment_shader_list = [];
		return this;
	}

	GpuGraphicsPipeline create_graphics_pipeline()
	{
		GpuGraphicsPipeline temp_graphics_pipeline;
		temp_graphics_pipeline = new GpuGraphicsPipeline(this.device);
		graphics_pipeline_list ~= temp_graphics_pipeline;
		return temp_graphics_pipeline;
	}

	typeof(this) release_graphics_pipeline()
	{
		foreach (index; 0 .. graphics_pipeline_list.length)
		{
			if (graphics_pipeline_list[index] is null)
			{
				continue;
			}
			graphics_pipeline_list[index].release();
			destroy(graphics_pipeline_list[index]);
		}
		graphics_pipeline_list = [];
		return this;
	}

	GpuComputePipeline create_compute_pipeline()
	{
		GpuComputePipeline temp_compute_pipeline;
		temp_compute_pipeline = new GpuComputePipeline(this.device);
		compute_pipeline_list ~= temp_compute_pipeline;
		return temp_compute_pipeline;
	}

	typeof(this) release_compute_pipeline()
	{
		foreach (index; 0 .. compute_pipeline_list.length)
		{
			if (compute_pipeline_list[index] is null)
			{
				continue;
			}
			compute_pipeline_list[index].release();
			destroy(compute_pipeline_list[index]);
		}
		compute_pipeline_list = [];
		return this;
	}

	GpuVertexBuffer create_vertex_buffer()
	{
		GpuVertexBuffer temp_vertex_buffer;
		temp_vertex_buffer = new GpuVertexBuffer(this.device);
		vertex_buffer_list ~= temp_vertex_buffer;
		return temp_vertex_buffer;
	}

	typeof(this) release_vertex_buffer()
	{
		foreach (index; 0 .. vertex_buffer_list.length)
		{
			if (vertex_buffer_list[index] is null)
			{
				continue;
			}
			vertex_buffer_list[index].release();
			destroy(vertex_buffer_list[index]);
		}
		vertex_buffer_list = [];
		return this;
	}

	GpuIndexBuffer create_index_buffer()
	{
		GpuIndexBuffer temp_index_buffer;
		temp_index_buffer = new GpuIndexBuffer(this.device);
		index_buffer_list ~= temp_index_buffer;
		return temp_index_buffer;
	}

	typeof(this) release_index_buffer()
	{
		foreach (index; 0 .. index_buffer_list.length)
		{
			if (index_buffer_list[index] is null)
			{
				continue;
			}
			index_buffer_list[index].release();
			destroy(index_buffer_list[index]);
		}
		index_buffer_list = [];
		return this;
	}

	GpuDrawBuffer create_draw_buffer()
	{
		GpuDrawBuffer temp_draw_buffer;
		temp_draw_buffer = new GpuDrawBuffer(this.device);
		draw_buffer_list ~= temp_draw_buffer;
		return temp_draw_buffer;
	}

	typeof(this) release_draw_buffer()
	{
		foreach (index; 0 .. draw_buffer_list.length)
		{
			if (draw_buffer_list[index] is null)
			{
				continue;
			}
			draw_buffer_list[index].release();
			destroy(draw_buffer_list[index]);
		}
		draw_buffer_list = [];
		return this;
	}

	GpuTexture create_texture()
	{
		GpuTexture temp_texture;
		temp_texture = new GpuTexture(this.device);
		texture_list ~= temp_texture;
		return temp_texture;
	}

	typeof(this) release_texture()
	{
		foreach (index; 0 .. texture_list.length)
		{
			if (texture_list[index] is null)
			{
				continue;
			}
			texture_list[index].release();
			destroy(texture_list[index]);
		}
		texture_list = [];
		return this;
	}

	GpuSampler create_sampler()
	{
		GpuSampler temp_sampler;
		temp_sampler = new GpuSampler(this.device);
		sampler_list ~= temp_sampler;
		return temp_sampler;
	}

	typeof(this) release_sampler()
	{
		foreach (index; 0 .. sampler_list.length)
		{
			if (sampler_list[index] is null)
			{
				continue;
			}
			sampler_list[index].release();
			destroy(sampler_list[index]);
		}
		sampler_list = [];
		return this;
	}

	GfxUploadContext create_upload_context()
	{
		return new GfxUploadContext(this.device);
	}

	GfxRenderContext create_render_context()
	{
		return new GfxRenderContext(this.device, this.window);
	}

	GfxComputeContext create_compute_context()
	{
		return new GfxComputeContext(this.device, this.window);
	}

	GfxTextContext create_text_context()
	{
		return new GfxTextContext(this.device);
	}

	bool support_format(
		SDL_GPUTextureFormat format,
		SDL_GPUTextureType type,
		SDL_GPUTextureUsageFlags usage
	)
	in (this.device !is null)
	in (this.device.handle !is null)
	{
		return this.device.support_format(format, type, usage);
	}

	GpuTextureFormat get_swapchain_texture_format()
	in (this.device !is null)
	in (this.device.handle !is null)
	in (this.window !is null)
	in (this.window.handle !is null)
	{
		return cast(GpuTextureFormat) SDL_GetGPUSwapchainTextureFormat(
			this.device.handle, this.window.handle
		);
	}

	GpuShaderFormat get_shader_format()
	{
		return cast(GpuShaderFormat) cast(SDL_GPUShaderFormat) SDL_GetGPUShaderFormats(
			this.device.handle
		);
	}

	string output_shader_format()
	{
		import std.array : join;

		GpuShaderFormat formats = get_shader_format();
		string spport_spirv = "SPIRV:" ~ ((formats & GpuShaderFormat.spirv) ? "y" : "n");
		string spport_msl = "MSL:" ~ ((formats & GpuShaderFormat.msl) ? "y" : "n");
		string spport_dxil = "DXIL:" ~ ((formats & GpuShaderFormat.dxil) ? "y" : "n");
		return join([spport_spirv, spport_msl, spport_dxil], " ");
	}

	string output_driver_list()
	{
		return format("supported driver: %(%s,%)", this.device.get_driver_list());
	}

	private Class create_in_list(Class, alias List)()
	{
		Class temp;
		temp = new Class(this.device);
		this.List ~= temp;
		return temp;
	}

	private typeof(this) release_list(alias List)()
	{
		foreach (index; 0 .. List.length)
		{
			if (List[index] is null)
			{
				continue;
			}
			List[index].release();
			destroy(List[index]);
		}
		List = [];
		return this;
	}
}

GpuComputePipeline initialize(
	ref GpuComputePipeline pipeline,
	ref GfxGraphicsContext graphics_context,
)
{
	if (pipeline !is null)
	{
		return pipeline;
	}
	pipeline = new GpuComputePipeline(graphics_context.device);
	graphics_context.register(pipeline);
	return pipeline;
}

GpuComputePipeline initialize(
	ref GpuComputePipeline pipeline,
	ref GfxGraphicsContext graphics_context,
	GpuComputePipelineCreateInfo pipeline_create_info,
)
{
	if (pipeline is null)
	{
		pipeline = new GpuComputePipeline(graphics_context.device);
		graphics_context.register(pipeline);
	}
	if (pipeline.handle is null)
	{
		pipeline.create(pipeline_create_info);
	}
	return pipeline;
}
