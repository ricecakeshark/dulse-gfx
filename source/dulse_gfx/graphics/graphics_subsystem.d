module dulse_gfx.graphics.graphics_subsystem;

import dulse_gfx;

import dulse.core.core;
import dulse.core.subsystem;
import dulse.core.container.resource_store;

import std.exception : enforce;

class GfxGraphicsSubsystem : Subsystem
{
	GfxGraphicsContext _context;

	this(Core core)
	{
		super(core);
	}

	typeof(this) initialize()
	{
		this._context = new GfxGraphicsContext();
		return this;
	}

	typeof(this) finalize()
	{
		return this;
	}

	typeof(this) process()
	{
		return this;
	}

	@property ref GfxGraphicsContext context()
	{
		enforce(this._context !is null);
		return this._context;
	}
}
