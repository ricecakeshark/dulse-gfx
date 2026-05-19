module kelp_gfx.subsystem.graphics_subsystem;

import kelp_gfx;

import kelp_core.core.core;
import kelp_core.core.subsystem;
import kelp_core.core.container.resource_store;

import std.exception;

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
