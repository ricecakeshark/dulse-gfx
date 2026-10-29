module dulse_gfx.graphics.resource.texture;

import dulse_sdl.graphics;
import dulse_gfx.graphics;
import std.exception : enforce;

alias Texture = GfxTexture;
alias SwapchainTexture = GpuSwapchainTexture;

class GfxTexture : GpuTexture
{
	GraphicsContext context;
	GpuSampler sampler;
	GpuTextureCreateInfo create_info;

	this(GraphicsContext gc)
	{
		this.context = gc;
		super(gc.device);
		return;
	}

	@property GpuTextureSamplerBinding binding() pure nothrow @nogc @safe
	in (super.is_valid, "Texture is invalid")
	in (this.sampler !is null, "sampler is null")
	in (this.sampler.is_valid, "sampelr is invalid")
	{
		return GpuTextureSamplerBinding(
			this,
			this.sampler,
		);
	}

	typeof(this) set(TypeList...)(TypeList settable_list)
	{
		foreach (ref settable; settable_list)
		{
			this.set(settable);
		}
		return this;
	}

	typeof(this) set(GpuTextureCreateInfo create_info)
	{
		this.create_info = create_info;
		return this;
	}

	typeof(this) set(GpuSampler sampler)
	in (sampler !is null)
	{
		this.sampler = sampler;
		return this;
	}

	typeof(this) create()
	in (this.create_info != GpuTextureCreateInfo.init)
	in (this.sampler !is null)
	{
		super.create(this.create_info);
		return this;
	}

	alias create = GpuTexture.create;
}
