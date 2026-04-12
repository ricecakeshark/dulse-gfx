module kelp_gfx.graphics_context;

import bindbc.sdl;
import kelp_sdl;
import kelp_gfx;
import std.format : format;

class GfxGraphicsContext
{
	public GpuDevice device;
	public GpuWindow window;

	public int client_width, client_height;

	protected GpuGraphicsPipeline[] graphics_pipeline_list;
	protected GpuComputePipeline[] compute_pipeline_list;
	protected GpuVertexShader[] vertex_shader_list;
	protected GpuFragmentShader[] fragment_shader_list;
	protected GpuBufferTransferBuffer[] buffer_transfer_buffer_list;
	protected GpuTextureTransferBuffer[] texture_transfer_buffer_list;
	protected GpuVertexBuffer[] vertex_buffer_list;
	protected GpuIndexBuffer[] index_buffer_list;
	protected GpuDrawBuffer[] draw_buffer_list;
	protected GpuStorageBuffer[] storage_buffer_list;
	protected GpuTexture[] texture_list;
	protected GpuSampler[] sampler_list;

	protected GfxTextContext[] text_context_list;

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

	typeof(this) initialize(
		in int client_width,
		in int client_height,
		in GpuBackend backend = GpuBackend.none)
	{
		this.device = new GpuDevice();
		this.device.create(backend);
		this.window = new GpuWindow();
		this.window.create(client_width, client_height, "");
		this.client_width = client_width;
		this.client_height = client_height;
		this.device.claim(this.window);
		debug
		{
			import std.stdio;

			this.output_driver_list().writeln();
			this.output_shader_format().writeln();
		}
		return this;
	}

	typeof(this) finalize()
	{
		this.release_all();
		this.release();
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
		release_all_them(
			graphics_pipeline_list,
			compute_pipeline_list,
			vertex_shader_list,
			fragment_shader_list,

			buffer_transfer_buffer_list,
			texture_transfer_buffer_list,

			vertex_buffer_list,
			index_buffer_list,
			draw_buffer_list,
			storage_buffer_list,

			texture_list,
			sampler_list,

			text_context_list,
		);
		return this;
	}

	typeof(this) release_all_shader()
	{
		release_all_them(
			vertex_shader_list,
			fragment_shader_list,
		);
		return this;
	}

	typeof(this) release_transfer_buffer()
	{
		release_all_them(
			buffer_transfer_buffer_list,
			texture_transfer_buffer_list,
		);
		return this;
	}

	typeof(this) release_buffer()
	{
		release_all_them(
			this.vertex_buffer_list,
			this.index_buffer_list,
			this.draw_buffer_list,
			this.storage_buffer_list,
		);
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
	// vertex shader
	typeof(this) create(out GpuVertexShader vertex_shader)
	{
		vertex_shader = new GpuVertexShader(this.device);
		this.vertex_shader_list ~= vertex_shader;
		return this;
	}

	typeof(this) release_vertex_shader()
	{
		release_all_them(this.vertex_shader_list);
		return this;
	}
	// fragment shader
	typeof(this) create(out GpuFragmentShader fragment_shader)
	{
		fragment_shader = new GpuFragmentShader(this.device);
		this.fragment_shader_list ~= fragment_shader;
		return this;
	}

	typeof(this) release_fragment_shader()
	{
		release_all_them(this.fragment_shader_list);
		return this;
	}
	// graphics pipeline
	typeof(this) create(out GpuGraphicsPipeline pipeline)
	{
		pipeline = new GpuGraphicsPipeline(this.device);
		graphics_pipeline_list ~= pipeline;
		return this;
	}

	typeof(this) release_graphics_pipeline()
	{
		release_all_them(this.graphics_pipeline_list);
		return this;
	}
	// compute pipeline
	typeof(this) create(out GpuComputePipeline pipeline)
	{
		pipeline = new GpuComputePipeline(this.device);
		compute_pipeline_list ~= pipeline;
		return this;
	}

	typeof(this) release_compute_pipeline()
	{
		release_all_them(this.compute_pipeline_list);
		return this;
	}
	// buffer transfer buffer
	typeof(this) create(out GpuBufferTransferBuffer transfer_buffer)
	{
		transfer_buffer = new GpuBufferTransferBuffer(this.device);
		buffer_transfer_buffer_list ~= transfer_buffer;
		return this;
	}

	typeof(this) release_buffer_transfer_buffer()
	{
		release_all_them(buffer_transfer_buffer_list);
		return this;
	}
	// texture transfer buffer
	typeof(this) create(out GpuTextureTransferBuffer transfer_buffer)
	{
		transfer_buffer = new GpuTextureTransferBuffer(this.device);
		texture_transfer_buffer_list ~= transfer_buffer;
		return this;
	}

	typeof(this) release_texture_transfer_buffer()
	{
		release_all_them(texture_transfer_buffer_list);
		return this;
	}
	// vertex buffer
	typeof(this) create(out GpuVertexBuffer buffer)
	{
		buffer = new GpuVertexBuffer(this.device);
		vertex_buffer_list ~= buffer;
		return this;
	}

	typeof(this) release_vertex_buffer()
	{
		release_all_them(this.vertex_buffer_list);
		return this;
	}
	// index buffer
	typeof(this) create(out GpuIndexBuffer buffer)
	{
		buffer = new GpuIndexBuffer(this.device);
		index_buffer_list ~= buffer;
		return this;
	}

	typeof(this) release_index_buffer()
	{
		release_all_them(this.index_buffer_list);
		return this;
	}
	// draw buffer
	typeof(this) create(out GpuDrawBuffer buffer)
	{
		buffer = new GpuDrawBuffer(this.device);
		draw_buffer_list ~= buffer;
		return this;
	}

	typeof(this) release_draw_buffer()
	{
		release_all_them(this.draw_buffer_list);
		return this;
	}
	// storage buffer
	typeof(this) create(out GpuStorageBuffer buffer)
	{
		buffer = new GpuStorageBuffer(this.device);
		storage_buffer_list ~= buffer;
		return this;
	}

	typeof(this) release_storage_buffer()
	{
		release_all_them(this.storage_buffer_list);
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
		release_all_them(this.texture_list);
		return this;
	}
	// sampler
	typeof(this) create(out GpuSampler sampler)
	{
		sampler = new GpuSampler(this.device);
		sampler_list ~= sampler;
		return this;
	}

	typeof(this) release_sampler()
	{
		release_all_them(this.sampler_list);
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
		this.text_context_list ~= context;
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

void release_all_them(TypeList...)(ref TypeList releasable_list_list)
{
	foreach (ref releasable_list; releasable_list_list)
	{
		release(releasable_list);
	}
	return;
}

void release(Type)(ref Type[] releasable_list)
{
	foreach (ref releasable; releasable_list)
	{
		releasable.release();
		destroy(releasable);
	}
	releasable_list = null;
	return;
}
