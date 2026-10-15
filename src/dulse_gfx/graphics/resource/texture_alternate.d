module dulse_gfx.graphics.resource.texture_alternate;

import dulse_sdl.graphics;
import dulse_gfx.graphics;

alias TextureAlternate = GfxTextureAlternate;

struct GfxTextureAlternate
{
	int swap_state = 0;
	Texture texture_alpha, texture_beta;

	this(GfxGraphicsContext context)
	{
		texture_alpha = new Texture(context);
		texture_beta = new Texture(context);
		/+context.create(
			this.texture_alpha,
			this.texture_beta,
		);+/
		return;
	}

	@property GpuTexture src() pure nothrow @nogc @safe
	{
		return (swap_state % 2 == 0) ?
			this.texture_alpha : this.texture_beta;
	}

	@property GpuTexture dest() pure nothrow @nogc @safe
	{
		return (swap_state % 2 == 0) ?
			this.texture_beta : this.texture_alpha;
	}

	typeof(this) create(in GpuTextureCreateInfo tci)
	{
		this.texture_alpha.create(tci);
		this.texture_beta.create(tci);
		return this;
	}

	typeof(this) release()
	{
		this.texture_alpha.release();
		this.texture_beta.release();
		return this;
	}

	typeof(this) reset() pure nothrow @nogc @safe
	{
		this.swap_state = 0;
		return this;
	}

	typeof(this) reset(in typeof(swap_state) swap_state) pure nothrow @nogc @safe
	{
		this.swap_state = swap_state % 2;
		return this;
	}

	typeof(this) swap() pure nothrow @nogc @safe
	{
		this.swap_state = (swap_state + 1) % 2;
		return this;
	}
}
