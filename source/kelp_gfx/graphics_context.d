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
	// variable creation
	typeof(this) create(TypeList...)(out TypeList arg_list)
	{
		static foreach (arg; arg_list)
		{
			this.create(arg);
		}
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

	typeof(this) create(out GpuVertexShader vertex_shader)
	{
		vertex_shader = new GpuVertexShader(this.device);
		this.vertex_shader_list ~= vertex_shader;
		return this;
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

	typeof(this) create(out GpuFragmentShader fragment_shader)
	{
		fragment_shader = new GpuFragmentShader(this.device);
		this.fragment_shader_list ~= fragment_shader;
		return this;
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

	typeof(this) create(out GpuGraphicsPipeline pipeline)
	{

		pipeline = new GpuGraphicsPipeline(this.device);
		graphics_pipeline_list ~= pipeline;
		return this;
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

	typeof(this) create(out GpuComputePipeline pipeline)
	{
		pipeline = new GpuComputePipeline(this.device);
		compute_pipeline_list ~= pipeline;
		return this;
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

	typeof(this) create(out GpuBufferTransferBuffer transfer_buffer)
	{
		transfer_buffer = new GpuBufferTransferBuffer(this.device);
		return this;
	}

	typeof(this) create(out GpuTextureTransferBuffer transfer_buffer)
	{
		transfer_buffer = new GpuTextureTransferBuffer(this.device);
		return this;
	}

	typeof(this) create(out GpuVertexBuffer buffer)
	{
		buffer = new GpuVertexBuffer(this.device);
		vertex_buffer_list ~= buffer;
		return this;
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

	typeof(this) create(out GpuIndexBuffer buffer)
	{
		buffer = new GpuIndexBuffer(this.device);
		index_buffer_list ~= buffer;
		return this;
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

	typeof(this) create(out GpuDrawBuffer buffer)
	{
		buffer = new GpuDrawBuffer(this.device);
		draw_buffer_list ~= buffer;
		return this;
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
	// texture
	typeof(this) create(out GpuTexture texture)
	{
		texture = new GpuTexture(this.device);
		texture_list ~= texture;
		return this;
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

	typeof(this) create(out GpuSampler sampler)
	{
		sampler = new GpuSampler(this.device);
		sampler_list ~= sampler;
		return this;
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
	// upload context
	typeof(this) create(out GfxUploadContext context)
	{
		context = new GfxUploadContext(this.device);
		return this;
	}
	// render context
	typeof(this) create(out GfxRenderContext context)
	{
		context = new GfxRenderContext(this.device, this.window);
		return this;
	}
	// compute context
	typeof(this) create(out GfxComputeContext context)
	{
		context = new GfxComputeContext(this.device, this.window);
		return this;
	}
	// text context
	typeof(this) create(out GfxTextContext context)
	{
		context = new GfxTextContext(this.device);
		return this;
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
