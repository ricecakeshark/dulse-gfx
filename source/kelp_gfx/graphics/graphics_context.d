module kelp_gfx.graphics.graphics_context;

import bindbc.sdl;
import kelp_core.core.container;
import kelp_sdl;
import kelp_gfx;
import std.format : format;
import std.sumtype;

class GfxGraphicsContext
{
	public GpuDevice device;
	public GpuWindow window;
	protected int[3] _client_size;

	public ResourceStore!ResourceType resource_store;

	alias ResourceType = SumType!(

		GpuGraphicsPipeline,
		GpuComputePipeline,
		GpuVertexShader,
		GpuFragmentShader,
		GpuBufferTransferBuffer,
		GpuTextureTransferBuffer,
		GpuVertexBuffer,
		GpuIndexBuffer,
		GpuDrawBuffer,
		GpuStorageBuffer,
		GpuTexture,
		GpuSampler,
		GpuFence,
		GfxTextContext,
	);

	this()
	{
		this.resource_store = new ResourceStore!ResourceType();
		return;
	}

	@property int client_width() const pure nothrow @nogc @safe
	{
		return this._client_size[0];
	}

	@property int client_height() const pure nothrow @nogc @safe
	{
		return this._client_size[1];
	}

	@property int[3] client_size() const pure nothrow @nogc @safe
	{
		return this._client_size;
	}

	typeof(this) initialize(
		in int client_width,
		in int client_height,
		in string clinet_title,
		in GpuBackend backend = GpuBackend.none,
	)
	{
		this.device = new GpuDevice();
		this.device.create(backend);
		this.window = new GpuWindow();
		this.window.create(client_width, client_height, clinet_title);
		this._client_size = [client_width, client_height, 1];
		this.device.claim(this.window);
		return this;
	}

	typeof(this) finalize()
	{
		this.resource_store.release_all();
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

	// variable creation
	typeof(this) create(TypeList...)(out TypeList arg_list)
	{
		static foreach (arg; arg_list)
		{
			this.create(arg);
		}
		return this;
	}

	typeof(this) release_all_shader()
	{
		this.resource_store.release!(
			GpuVertexShader, GpuFragmentShader,
		);
		return this;
	}

	typeof(this) release_transfer_buffer()
	{
		this.resource_store.release!(
			GpuBufferTransferBuffer, GpuTextureTransferBuffer,
		);
		return this;
	}

	typeof(this) release_buffer()
	{
		this.resource_store.release!(
			GpuVertexBuffer,
			GpuIndexBuffer,
			GpuDrawBuffer,
			GpuStorageBuffer,
		);
		return this;
	}
	// command buffer
	typeof(this) create(out GpuCommandBuffer command_buffer)
	{
		command_buffer = new GpuCommandBuffer(this.device, this.window);
		return this;
	}
	// swapchain texture
	typeof(this) create(out GpuSwapchainTexture swapchain_texture)
	{
		swapchain_texture = new GpuSwapchainTexture(this.device, this.window);
		return this;
	}
	// vertex shader
	typeof(this) create(out GpuVertexShader vertex_shader)
	{
		vertex_shader = new GpuVertexShader(this.device);
		this.resource_store.register(vertex_shader);
		return this;
	}
	// fragment shader
	typeof(this) create(out GpuFragmentShader fragment_shader)
	{
		fragment_shader = new GpuFragmentShader(this.device);
		this.resource_store.register(fragment_shader);
		return this;
	}
	// graphics pipeline
	typeof(this) create(out GpuGraphicsPipeline pipeline)
	{
		pipeline = new GpuGraphicsPipeline(this.device);
		this.resource_store.register(pipeline);
		return this;
	}
	// compute pipeline
	typeof(this) create(out GpuComputePipeline pipeline)
	{
		pipeline = new GpuComputePipeline(this.device);
		this.resource_store.register(pipeline);
		return this;
	}
	// buffer transfer buffer
	typeof(this) create(out GpuBufferTransferBuffer transfer_buffer)
	{
		transfer_buffer = new GpuBufferTransferBuffer(this.device);
		this.resource_store.register(transfer_buffer);
		return this;
	}
	// texture transfer buffer
	typeof(this) create(out GpuTextureTransferBuffer transfer_buffer)
	{
		transfer_buffer = new GpuTextureTransferBuffer(this.device);
		this.resource_store.register(transfer_buffer);
		return this;
	}
	// vertex buffer
	typeof(this) create(out GpuVertexBuffer buffer)
	{
		buffer = new GpuVertexBuffer(this.device);
		this.resource_store.register(buffer);
		return this;
	}
	// index buffer
	typeof(this) create(out GpuIndexBuffer buffer)
	{
		buffer = new GpuIndexBuffer(this.device);
		this.resource_store.register(buffer);
		return this;
	}
	// draw buffer
	typeof(this) create(out GpuDrawBuffer buffer)
	{
		buffer = new GpuDrawBuffer(this.device);
		this.resource_store.register(buffer);
		return this;
	}
	// storage buffer
	typeof(this) create(out GpuStorageBuffer buffer)
	{
		buffer = new GpuStorageBuffer(this.device);
		this.resource_store.register(buffer);
		return this;
	}
	// texture
	typeof(this) create(out GpuTexture texture)
	{
		texture = new GpuTexture(this.device);
		this.resource_store.register(texture);
		return this;
	}
	// sampler
	typeof(this) create(out GpuSampler sampler)
	{
		sampler = new GpuSampler(this.device);
		this.resource_store.register(sampler);
		return this;
	}
	// fence
	typeof(this) create(out GpuFence fence)
	{
		fence = new GpuFence(this.device);
		this.resource_store.register(fence);
		return this;
	}
	// render context
	/+typeof(this) create(out GfxRenderContext context)
	{
		context = new GfxRenderContext(this);
		return this;
	}
	// compute context
	typeof(this) create(out GfxComputeContext context)
	{
		context = new GfxComputeContext(this);
		return this;
	}+/
	// text context
	typeof(this) create(out GfxTextContext context)
	{
		context = new GfxTextContext(this.device);
		this.resource_store.register(context);
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

	deprecated GpuTextureFormat get_swapchain_texture_format()
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
}
