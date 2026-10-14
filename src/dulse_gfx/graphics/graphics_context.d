module dulse_gfx.graphics.graphics_context;

import sdl.gpu;
import dulse.core.container;
import dulse_sdl.graphics;

import dulse_sdl.video.window;
import dulse_gfx.graphics;
import dulse_gfx.text.text_context;
import std.format : format;
import std.sumtype;
import std.meta : AliasSeq, staticIndexOf;

alias GraphicsContext = GfxGraphicsContext;

class GfxGraphicsContext
{
	public GpuDevice device;
	public Window window;
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
		GfxTexture,
		GpuSampler,
		GpuFence,
		GfxTextContext,
	);

	alias ResourcePipeline = AliasSeq!(
		GpuGraphicsPipeline,
		GpuComputePipeline,
	);
	alias ResourceShader = AliasSeq!(
		GpuVertexShader,
		GpuFragmentShader,
	);
	alias ResourceTransferBuffer = AliasSeq!(
		GpuBufferTransferBuffer,
		GpuTextureTransferBuffer,
	);
	alias ResourceBuffer = AliasSeq!(
		GpuVertexBuffer,
		GpuIndexBuffer,
		GpuDrawBuffer,
		GpuStorageBuffer,
	);
	alias ResourceTexture = AliasSeq!(
		GfxTexture,
		SwapchainTexture,
	);
	alias ResourceAbstract = AliasSeq!(
		GfxTextContext
	);
	alias ResourceReleasable = AliasSeq!(
		ResourcePipeline,
		ResourceShader,
		ResourceTransferBuffer,
		ResourceBuffer,
		Texture,
		TextureAlternate,
		GpuSampler,
		GpuFence,
	);

	alias GfxResource = AliasSeq!(GfxTexture, GfxTextureAlternate);

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
		this.window = new Window();
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
	typeof(this) create(TypeList...)(ref TypeList arg_list)
	{
		foreach (ref arg; arg_list)
		{
			this.create(arg);
		}
		return this;
	}

	typeof(this) create(Resource)(ref Resource resource)
	if (staticIndexOf!(Resource, ResourceReleasable) >= 0)
	{
		if (resource !is null)
		{
			return this;
		}
		static if (staticIndexOf!(Resource, GfxResource) >= 0)
		{
			resource = new Resource(this);
		}
		else
		{
			resource = new Resource(this.device);
		}
		this.resource_store.register(resource);
		return this;
	}

	// command buffer
	typeof(this) create(ref CommandBuffer command_buffer)
	{
		command_buffer = new CommandBuffer(this.device, this.window);
		return this;
	}
	// swapchain texture
	typeof(this) create(ref SwapchainTexture swapchain_texture)
	{
		swapchain_texture = new SwapchainTexture(this.device, this.window);
		return this;
	}
	// text context
	typeof(this) create(ref GfxTextContext context)
	{
		context = new GfxTextContext(this.device);
		this.resource_store.register(context);
		return this;
	}
	// texture alternate
	typeof(this) create(ref TextureAlternate texture_alternate)
	{
		texture_alternate = TextureAlternate(this);
		return this;
	}

	typeof(this) release(ResourceList...)()
	{
		this.resource_store.release!ResourceList();
		return this;
	}

	typeof(this) release_all_shader()
	{
		this.resource_store.release!ResourceShader();
		return this;
	}

	typeof(this) release_transfer_buffer()
	{
		this.resource_store.release!ResourceTransferBuffer();
		return this;
	}

	typeof(this) release_buffer()
	{
		this.resource_store.release!ResourceBuffer();
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
}

TexturePreset preset(ref GfxGraphicsContext gc,)
{
	return TexturePreset(gc);
}

struct TexturePreset
{
	GfxGraphicsContext gc;
	this(GfxGraphicsContext gc)
	{
		this.gc = gc;
		return;
	}

	GpuTextureCreateInfo depth()
	{
		return this._depth.apply(gc);
	}

	GpuTextureCreateInfo albedo()
	{
		return this._albedo.apply(gc);
	}

	GpuTextureCreateInfo normal()
	{
		return this._normal.apply(gc);
	}

	GpuTextureCreateInfo material()
	{
		return this._material.apply(gc);
	}

	GpuTextureCreateInfo entity()
	{
		return this._entity.apply(gc);
	}

	GpuTextureCreateInfo color()
	{
		return this._color.apply(gc);
	}

	GpuTextureCreateInfo edge()
	{
		return this._edge.apply(gc);
	}

	enum _depth = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.d32_float,
			GpuTextureUsageFlags.depth_stencil_target | GpuTextureUsageFlags.sampler,
			0, 0,
		);

	enum _albedo = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r8g8b8a8_unorm,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _normal = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r16g16b16a16_float,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _material = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r16g16b16a16_float,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _entity = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r32g32_int,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.color_target,
			0, 0, 1, 1,
		);
	enum _color = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r16g16b16a16_float,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.compute_storage_write,
			0, 0, 1, 1,
		);
	enum _edge = GpuTextureCreateInfo(
			GpuTextureType._2d, GpuTextureFormat.r8g8b8a8_unorm,
			GpuTextureUsageFlags.sampler | GpuTextureUsageFlags.compute_storage_write,
			0, 0, 1, 1,
		);
}

GpuTextureCreateInfo apply(GpuTextureCreateInfo info, GfxGraphicsContext gc)
{
	info.width = gc.client_width;
	info.height = gc.client_height;
	return info;
}

enum TexturePresetName
{
	albedo,
	normal,
	material,
	entity,
	color,
	edge,
}
